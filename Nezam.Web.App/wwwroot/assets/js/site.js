const svgContainer = document.getElementById('svg-container');
const a4Rect = document.getElementById('a4-rect');
const codeEditor = document.getElementById('codeEditor');
let elementIdCounter = 1;

function serializeToXML() {
    let xmlString = `<Report>\n  <Page id="A4" width="595.28" height="841.89">\n`;

    a4Rect.querySelectorAll('.element').forEach(element => {
        const type = element.getAttribute('data-type');
        const id = element.getAttribute('data-id');
        const x = element.style.left;
        const y = element.style.top;
        const width = element.style.width;
        const height = element.style.height;
        const content = element.textContent || '';

        xmlString += `    <Item type="${type}" id="${id}" x="${x}" y="${y}" width="${width}" height="${height}"${type === 'text' || type === 'counter' ? ` content="${content}"` : ''}/>\n`;
    });

    xmlString += `  </Page>\n</Report>`;
    return xmlString;
}

function updateCodeEditor() {
    codeEditor.value = serializeToXML();
}

function parseXMLAndUpdateView(xmlString) {
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(xmlString, "application/xml");

    // Clear existing elements
    while (a4Rect.firstChild) {
        a4Rect.removeChild(a4Rect.firstChild);
    }

    // Deserialize XML to elements
    xmlDoc.querySelectorAll("Item").forEach(item => {
        const type = item.getAttribute('type');
        const id = item.getAttribute('id');
        const x = item.getAttribute('x');
        const y = item.getAttribute('y');
        const width = item.getAttribute('width');
        const height = item.getAttribute('height');
        const content = item.getAttribute('content');

        if (type === 'text') {
            addTextElement(parseFloat(x), parseFloat(y), content, id);
        } else if (type === 'counter') {
            addCounterElement(parseFloat(x), parseFloat(y), parseInt(content.split(': ')[1]), content.split(': ')[0], id);
        } else if (type === 'section') {
            addSection(parseFloat(x), parseFloat(y), parseFloat(width), parseFloat(height), id);
        }
    });
}

function addElementToView(element) {
    a4Rect.appendChild(element);
    updateCodeEditor();
}

function addTextElement(x, y, textContent, id = `item-${elementIdCounter++}`) {
    const div = document.createElement('div');
    div.classList.add('element');
    div.setAttribute('data-type', 'text');
    div.setAttribute('data-id', id);
    div.style.position = 'absolute';
    div.style.left = `${x}px`;
    div.style.top = `${y}px`;
    div.style.width = 'auto';
    div.style.height = 'auto';
    div.textContent = textContent;

    makeDraggable(div);
    addElementToView(div);
}

function addCounterElement(x, y, count, textContent, id = `item-${elementIdCounter++}`) {
    const div = document.createElement('div');
    div.classList.add('element');
    div.setAttribute('data-type', 'counter');
    div.setAttribute('data-id', id);
    div.style.position = 'absolute';
    div.style.left = `${x}px`;
    div.style.top = `${y}px`;
    div.style.width = 'auto';
    div.style.height = 'auto';
    div.textContent = `${textContent}: ${count}`;

    makeDraggable(div);
    addElementToView(div);
}

function addSection(x, y, width, height, id = `item-${elementIdCounter++}`) {
    const section = document.createElement('div');
    section.classList.add('element');
    section.setAttribute('data-type', 'section');
    section.setAttribute('data-id', id);
    section.style.position = 'absolute';
    section.style.left = `${x}px`;
    section.style.top = `${y}px`;
    section.style.width = `${width}px`;
    section.style.height = `${height}px`;
    section.style.border = '2px solid #007bff';

    makeDraggable(section);
    makeResizable(section);
    addElementToView(section);
}

document.querySelectorAll('.toolbox-item').forEach(item => {
    item.addEventListener('dragstart', function (e) {
        e.dataTransfer.setData('text/plain', e.target.dataset.type);
    });
});

a4Rect.addEventListener('dragover', function (e) {
    e.preventDefault();
});

a4Rect.addEventListener('drop', function (e) {
    e.preventDefault();
    const type = e.dataTransfer.getData('text/plain');
    const x = e.offsetX;
    const y = e.offsetY;

    if (type === 'text') {
        addTextElement(x, y, 'New Text');
    } else if (type === 'counter') {
        addCounterElement(x, y, 0, 'Counter Text');
    } else if (type === 'section') {
        addSection(x, y, 200, 200); // Default size for a new section
    }
});

function makeDraggable(element) {
    let offsetX, offsetY;
    let isDragging = false;

    element.addEventListener('mousedown', function(e) {
        e.stopPropagation();
        isDragging = true;
        offsetX = e.clientX - element.getBoundingClientRect().left;
        offsetY = e.clientY - element.getBoundingClientRect().top;
        svgContainer.style.cursor = 'grabbing';
    });

    document.addEventListener('mousemove', function(e) {
        if (isDragging) {
            const newX = e.clientX - offsetX + svgContainer.scrollLeft;
            const newY = e.clientY - offsetY + svgContainer.scrollTop;

            element.style.left = `${newX}px`;
            element.style.top = `${newY}px`;

            updateCodeEditor(); // Update code when view changes
        }
    });

    document.addEventListener('mouseup', function() {
        if (isDragging) {
            isDragging = false;
            svgContainer.style.cursor = 'grab';
        }
    });
}

function makeResizable(element) {
    const handleSize = 8;

    // Create resizing handles
    const handles = [
        { x: 0, y: 0, cursor: 'nwse-resize' }, // top-left
        { x: 1, y: 0, cursor: 'nesw-resize' }, // top-right
        { x: 0, y: 1, cursor: 'nesw-resize' }, // bottom-left
        { x: 1, y: 1, cursor: 'nwse-resize' }  // bottom-right
    ].map(handle => {
        const div = document.createElement('div');
        div.style.position = 'absolute';
        div.style.width = `${handleSize}px`;
        div.style.height = `${handleSize}px`;
        div.style.backgroundColor = '#007bff';
        div.style.cursor = handle.cursor;
        div.style.left = `${handle.x * 100}%`;
        div.style.top = `${handle.y * 100}%`;
        div.style.transform = `translate(${handle.x * -50}%, ${handle.y * -50}%)`;
        div.addEventListener('mousedown', startResizing);
        element.appendChild(div);
        return { div, ...handle };
    });

    function startResizing(e) {
        e.stopPropagation();
        const handle = handles.find(h => h.div === e.target);
        const startX = e.clientX;
        const startY = e.clientY;
        const startWidth = parseFloat(getComputedStyle(element).width);
        const startHeight = parseFloat(getComputedStyle(element).height);
        const startLeft = parseFloat(getComputedStyle(element).left);
        const startTop = parseFloat(getComputedStyle(element).top);

        const onMouseMove = (e) => {
            const dx = e.clientX - startX;
            const dy = e.clientY - startY;

            const newWidth = startWidth + dx * (handle.x === 0 ? -1 : 1);
            const newHeight = startHeight + dy * (handle.y === 0 ? -1 : 1);

            if (newWidth > 20) {
                element.style.width = `${newWidth}px`;
                if (handle.x === 0) element.style.left = `${startLeft + dx}px`;
            }
            if (newHeight > 20) {
                element.style.height = `${newHeight}px`;
                if (handle.y === 0) element.style.top = `${startTop + dy}px`;
            }

            updateCodeEditor();
        };

        const onMouseUp = () => {
            document.removeEventListener('mousemove', onMouseMove);
            document.removeEventListener('mouseup', onMouseUp);
        };

        document.addEventListener('mousemove', onMouseMove);
        document.addEventListener('mouseup', onMouseUp);
    }
}

// Update view when code editor content changes
codeEditor.addEventListener('input', function() {
    parseXMLAndUpdateView(codeEditor.value);
});

// Scroll handling
svgContainer.addEventListener('mousedown', function(e) {
    e.preventDefault();

    let startX = e.pageX - svgContainer.offsetLeft;
    let startY = e.pageY - svgContainer.offsetTop;
    let scrollLeft = svgContainer.scrollLeft;
    let scrollTop = svgContainer.scrollTop;

    

    function onMouseMove(e) {
        svgContainer.scrollLeft = scrollLeft - (e.pageX - startX);
        svgContainer.scrollTop = scrollTop - (e.pageY - startY);
    }

    function onMouseUp() {
        svgContainer.removeEventListener('mousemove', onMouseMove);
        svgContainer.removeEventListener('mouseup', onMouseUp);
        svgContainer.style.cursor = 'grab';
    }

    svgContainer.addEventListener('mousemove', onMouseMove);
    svgContainer.addEventListener('mouseup', onMouseUp);
    svgContainer.style.cursor = 'grabbing';

});

// Initial serialization
updateCodeEditor();