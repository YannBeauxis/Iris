function display_table(data, id) {
  var color = true;
  var colorclass;
  var host = "http://" + location.host;
  
  var tb = document.createElement('table');  
  tb.setAttribute("class", "colored");
  document.getElementById(id).appendChild(tb);
  
  if (data.hasOwnProperty('header')) {
    var thead = document.createElement('thead');
    tb.appendChild(thead);
    var row  = create_row(thead, "type");
    var col = create_col(row, "none");
    for (index = 0; index < data.header.length; ++index) {
      var col = create_col(row, "none", 'th');
      col.innerHTML = data.header[index];
    }
  }
  
    for (index = 0; index < data.content.length; ++index ) {
      var cat = data.content[index];
      var row  = create_row(tb, "type");
      var col = create_col (row, "category");
      create_link(col, host + cat.url, cat.name);
      var items = cat.items;
      for (ind = 0; ind < items.length; ++ind ) {
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
          for (ind3 = 0; ind3 < item.content.length; ++ind3 ) {
            var col = create_col (row, 'value');
            col.innerHTML = item.content[ind3];
          }
        }
      }
    }
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
