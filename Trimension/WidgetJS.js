var input = document.querySelector('.input');
const container = document.querySelector('.container');
const clearAllButton = document.querySelector('.clear-all');

var currentDate = new Date();
var options = { year: 'numeric', month: 'numeric', day: 'numeric' };
var dateString = currentDate.toLocaleString('en-US', options);
var date = document.querySelector('.date');
date.textContent = dateString;


class item {
    constructor(itemName) {
        this.createDiv(itemName);
    }

    createDiv(itemName) {
        let input = document.createElement('input');
        input.value = itemName;
        input.disabled = true;
        input.classList.add('item-input');
        input.type = "text";

        let itemBox = document.createElement('div');
        itemBox.classList.add('item');

        let doneButton = document.createElement('button');
        doneButton.innerHTML = "";
        doneButton.classList.add('doneButton');

        container.appendChild(itemBox);

        itemBox.appendChild(input);
        itemBox.appendChild(doneButton);

        doneButton.addEventListener('click', () => this.done(input, doneButton));
    }

    done(input, doneButton) {
        input.style.textDecoration = input.style.textDecoration !== 'line-through' ? 'line-through' : 'none';
        doneButton.classList.toggle('clicked');
    }

}

function check() {
    if (input.value != "") {
        new item(input.value);
        input.value = "";
    }
}

input.addEventListener('keypress', function (event) {
    if (event.key === 'Enter') {
        check();
    }
});

clearAllButton.addEventListener('click', function () {
    container.innerHTML = '';
});




