$(function () { // When DOM is ready
  $.get('./tsv/organisms', (res) => {
    setupAutocomplete(res.trim().split('\n'));
    setupAutocomplete2(res.trim().split('\n'));
  });
  $('#tags').focus();

  const inputText = document.getElementById("inputText");
  const submitButton = document.getElementById("submitButton");

  submitButton.addEventListener("click", function () {
    submitText(inputText.value);
  });

  inputText.addEventListener("keydown", function (event) {
    if (event.key === "Enter" && event.ctrlKey) {
      event.preventDefault(); // デフォルトのEnterキーの動作をキャンセル
      submitText(inputText.value);
    }
  });

  function submitText(text) {
    const lines = text.split(/\r\n|\r|\n/)
        .map(line => line.trim().replace(/^\s+/, ""))
        .filter(line => line !== "") // remove empty lines
        .map(line => `(ncbigene:${line})`).join(" ");
    const tags = document.getElementById("tags").value.replace(/ \(.+\)$/, '');
    const tags2 = document.getElementById("tags2").value.replace(/ \(.+\)$/, '');
    fetchDatabySPARQL(tags, tags2, lines).then(data => {
      renderTable(data);
    });
  }

  function setupAutocomplete(candidates) {
    $('#tags').autocomplete({
      source: (request, response) => {
        response(
          $.grep(candidates, (value) => {
            let regexp = new RegExp('\\b' + escapeRegExp(request.term), 'i');
            return value.match(regexp);
          })
        );
      },
      autoFocus: true,
      delay: 100,
      minLength: 2,
    });
  }

  function setupAutocomplete2(candidates) {
    $('#tags2').autocomplete({
      source: (request, response) => {
        response(
          $.grep(candidates, (value) => {
            let regexp = new RegExp('\\b' + escapeRegExp(request.term), 'i');
            return value.match(regexp);
          })
        );
      },
      autoFocus: true,
      delay: 100,
      minLength: 2,
    });
  }
});

function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}
function renderTable(data) {
  const table = document.getElementById('resultsTable');
  table.innerHTML = '';

  const thead = document.createElement('thead');
  const headerRow = document.createElement('tr');
  data.head.vars.forEach(variable => {
    const th = document.createElement('th');
    th.textContent = variable;
    headerRow.appendChild(th);
  });
  thead.appendChild(headerRow);
  table.appendChild(thead);

  const tbody = document.createElement('tbody');
  data.results.bindings.forEach(binding => {
    const tr = document.createElement('tr');
    data.head.vars.forEach(variable => {
      const td = document.createElement('td');
      const value = binding[variable].value;
      if (value.match(/^http/)) {
        let link = document.createElement('a');
        link.href = value;
        link.textContent = value.replace(/.*\//, '');
        td.appendChild(link);
      } else {
        td.textContent = value;
      }
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });
  table.appendChild(tbody);
}
