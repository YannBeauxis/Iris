function display_table(data, id, col_visible) {
  var color = true;
  var colorclass;
  var host = "http://" + location.host;
  
  var tb = document.createElement('table');  
  tb.setAttribute("class", "table");
  
  var has_header = data.hasOwnProperty('header');
  var col_id = [];
  
  if (has_header) {
    var thead = document.createElement('thead');
    tb.appendChild(thead);
    var row  = create_row(thead, "title");
    var col = create_col(row, "none", 'th');
    //col.innerText = "Titre";
    for (index = 0; index < data.header.length; ++index) {
      var col = create_col(row, "none", 'th');
      $(col).hide();
      col.innerHTML = data.header[index].header;
      col_id[index] = data.header[index].id;
    }
  }
  
  var tbody = document.createElement('tbody');
  tb.appendChild(tbody);
  
  // category rows
    for (var ind1 = 0; ind1 < data.content.length; ++ind1 ) {
      var cat = data.content[ind1];
      var row  = create_row(tbody, "type");
      var col = create_col (row, "category");
      create_link(col, host + cat.url, cat.name);
      // category columns
      if (has_header) {
           for (ind2 = 0; ind2 < data.header.length; ++ind2) {
            var col = create_col(row, "none", 'td');
            $(col).hide();
            //col.innerHTML = "";
            col.setAttribute("col_id", data.header[ind2].id);    
          }          
        }
      var items = cat.items;
      // items rows
      for (var ind3 = 0; ind3 < items.length; ++ind3 ) {
        var item = items[ind3];
        if (color) {
          colorclass = "filled";
        }
        else {
          colorclass = "blank";
        }
        color = !color;
        var row  = create_row(tbody, colorclass);
        var col = create_col(row, "item");
        link = create_link(col, host + item.url, item.name);
        if (item.hasOwnProperty('columns')) {
          for (var ind4 = 0; ind4 < item.columns.length; ++ind4 ) {
            var col = create_col (row, 'value');
            if (has_header) {
              col.setAttribute("col_id", data.header[ind4].id);              
            }
            $(col).hide();
            col.innerHTML = item.columns[ind4];
          }
        }
      }
    }
  if (has_header) {
    var index_col = col_id.indexOf(col_visible);
    if ( index_col > -1){
      var col_set_visible = thead.firstChild.childNodes[index_col +1];
      $(col_set_visible).show();
      $(tb).find("[col_id='" + col_visible + "']").show();
    }
  }

  var div_target = document.getElementById(id);

  while (div_target.firstChild) {
      div_target.removeChild(div_target.firstChild);
  }
  div_target.appendChild(tb);

}

function create_row (parent, rowclass) {
  var row = document.createElement("tr");
  row.setAttribute("class", rowclass);
  parent.appendChild(row);
  return row;
}

function create_col (parent, colclass, coltype) {
  coltype = (typeof coltype === 'undefined') ? 'td' : coltype;
  var col = document.createElement(coltype);
  col.setAttribute("class", colclass);
  parent.appendChild(col);
  return col;
}

function create_link (parent, url, text) {
  var link = document.createElement('a');
  link.setAttribute("href", url);
  parent.appendChild(link);
  $(link).text(text);
}
