var ready = function() {
  console.log('ready');
  $('.data-table').DataTable({
        "scrollX": true
    });
};

$(document).ready(ready);