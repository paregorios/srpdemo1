// Look up related works
  var identifiers = jQuery("a[property='identifier']");
  identifiers.each(function(i, a){
    jQuery.getJSON("http://isaw2.atlantides.org/sparql?query="
              + encodeURIComponent("prefix dc: <http://purl.org/dc/terms/> "
              + "prefix rda-roles: <http://rdvocab.info/roles/> "
              + "prefix rdf: <http://www.w3.org/2000/01/rdf-schema#> "
              + "select ?work ?title ?mss ?mstitle ?url "
              + "from <http://isaw2.atlantides.org/srp/graph> "
              + "where { ?work rda-roles:author <" + a.href + "> . "
              + "        ?work dc:title ?title . "
              + "        optional {?work dc:isPartOf ?mss . "
              + "                  ?mss dc:title ?mstitle } . "
              + "        optional {?work dc:references ?url} }")
              + "&format=json", function(data) {
                  if (data.results.bindings.length > 0) {
                    jQuery("#works p").replaceWith('<ul id="worklist" class="bulleted"></ul>');
                    jQuery.each(data.results.bindings, function(i, row) {
                      if (row.url) {
                        jQuery("#worklist").append('<li><a href="'+ row.url.value +'">' + row.title.value +'</a>' + (row.mss ? ' (MS: <a href="' + row.mss.value + '">' + row.mstitle.value + '</a>)':'')+'</li>');
                      } else {
                        jQuery("#worklist").append('<li><a href="'+ row.work.value +'">' + row.title.value +'</a>' + (row.mss ? ' (MS: <a href="' + row.mss.value + '">' + row.mstitle.value + '</a>)':'')+'</li>');
                      }
                    });
                  } else {
                    jQuery("#works p").replaceWith("<p>No works found.</p>");
                  }
          });
  });