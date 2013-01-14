// Look up related works
  var identifiers = jQuery("a[property='identifier']");
  identifiers.each(function(i, a){
    jQuery.getJSON("http://isaw2.atlantides.org/sparql?query="
              + encodeURIComponent("prefix dc: <http://purl.org/dc/terms/> "
              + "prefix rda-roles: <http://rdvocab.info/roles/> "
              + "prefix rdf: <http://www.w3.org/2000/01/rdf-schema#> "
              + "prefix foaf: <http://xmlns.com/foaf/0.1/>"
              + "select ?work ?title ?ms ?mstitle ?msurl "
              + "from <http://isaw2.atlantides.org/srp/graph> "
              + "where { ?work rda-roles:author <" + a.href + "> . "
              + "        ?work dc:title ?title . "
              + "        ?work dc:isPartOf ?ms . "
              + "        ?ms dc:title ?mstitle . "
              + "        optional {?ms foaf:isPrimaryTopicOf ?msurl} }")
              + "&format=json", function(data) {
                  if (data.results.bindings.length > 0) {
                    jQuery("#works p").replaceWith('<h4>(318 results from <a href="http://www.mss-syriaques.org">ektobe</a>, <a href="http://www.hmml.org">HMML</a>, <a href="http://www.fihrist.org.uk">Fihrist</a>, <a href="#">see all results</a>)</h4><ul id="worklist" class="bulleted"></ul>');
                    jQuery.each(data.results.bindings, function(i, row) {
                      if (row.msurl) {
                        jQuery("#worklist").append('<li>MS: <a href="' + row.msurl.value + '">' + row.mstitle.value + '</a>: ' + row.title.value +'</li>');
                      } else {
                        jQuery("#worklist").append('<li>MS: <a href="' + row.ms.value + '">' + row.mstitle.value + '</a>: <a href="'+ row.work.value +'">' + row.title.value +'</a></li>');
                      }
                    });
                  } else {
                    jQuery("#works p").replaceWith("<p>No works found.</p>");
                  }
          });
  });