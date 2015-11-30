function display_table(data, id, col_visible) {
  var color = true;
  var colorclass;
  var host = "http://" + location.host;
  
  var tb = document.createElement('table');  
  tb.setAttribute("class", "colored");
  
  var has_header = data.hasOwnProperty('header');
  
  if (has_header) {
    var thead = document.createElement('thead');
    tb.appendChild(thead);
    var row  = create_row(thead, "type");
    var col = create_col(row, "none");
    for (index = 0; index < data.header.length; ++index) {
      var col = create_col(row, "none", 'th');
      $(col).hide();
      col.innerHTML = data.header[index];
    }
  }
  
    for (var index = 0; index < data.content.length; ++index ) {
      var cat = data.content[index];
      var row  = create_row(tb, "type");
      var col = create_col (row, "category");
      create_link(col, host + cat.url, cat.name);
      var items = cat.items;
      for (var ind = 0; ind < items.length; ++ind ) {
        var item = items[ind];
        if (color) {
          colorclass = "filled";
        }
        else {
          colorclass = "blank";
        }
        color = !color;
        var row  = create_row(tb, colorclass);
        var col = create_col (row, "item");
        create_link(col, host + item.url, item.name);
        if (item.hasOwnProperty('content')) {
          for (var ind3 = 0; ind3 < item.content.length; ++ind3 ) {
            var col = create_col (row, 'value');
            if (has_header) {
              col.setAttribute("col_name", data.header[ind3]);              
            }
            $(col).hide();
            col.innerHTML = item.content[ind3];
          }
        }
      }
    }
  if (has_header) {
    var index_col = data.header.indexOf(col_visible);
    if ( index_col > -1){
      var col_set_visible = thead.firstChild.childNodes[index_col +1];
      $(col_set_visible).show();
      $(tb).find("[col_name='" + col_visible + "']").show();
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
