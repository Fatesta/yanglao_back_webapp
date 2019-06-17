/*

new SArticleEditor('planArticleEditor', {
  baseUrl: CONFIG.baseUrl + '/health/house/eval/plan/article/element/',
  serviceOperationExtraParams: function() {
    return {articleId: articleId};
  }
});
*/
function SArticleEditor(containerId, options) {
    var ElementCreators = {
        h1: function(sArtElem) {
            var h = document.createElement('h1');
            $(h).html(elementTextContentToHtml(sArtElem.text));
            return h;
        },
        p: function(sArtElem) {
            var p = document.createElement('p');
            $(p).html(elementTextContentToHtml(sArtElem.text));
            return p;
        },
        img: function(sArtElem) {
            var img = document.createElement('img');
            img.src = sArtElem.url;
            return img;
        },
        video: function(sArtElem) {
            var video = document.createElement('video');
            video.src = sArtElem.url;
            video.controls = true;
            return video;
        },
    };

    var ElementEditors = {
        h1: function(isInsertAction, updateElem) {
            var dialog = openEditDialog({
                width: 400,
                height: 100,
                title: (isInsertAction ? '插入' : '修改') + '标题',
                content: '<input name="text" class="easyui-textbox" style="width:390px;"/>',
                onSave: function() {
                    var text = dialog.find('[textboxname=text]').textbox('getValue');
                    if (!text)
                        return;
                    var html = elementTextContentToHtml(text);
                    if (isInsertAction) {
                        insert({type: 'h1', text: html});
                    } else {
                        $(updateElem).html(html);
                        sArtNodeIdMap[updateElem.id].data.text = text;
                    }
                    dialog.dialog('destroy');
                }
            });
            if (!isInsertAction) {
                dialog.find('[textboxname=text]').textbox('setValue', updateElem.innerText);
            }
        },
        p: function(isInsertAction, updateElem) {
            var dialog = openEditDialog({
                width: 406,
                height: 300,
                title: (isInsertAction ? '插入' : '修改') + '段落',
                content: '<input name="text" class="easyui-textbox" data-options="multiline:true" style="height:240px;width:390px;"/>',
                onSave: function() {
                    var text = dialog.find('[textboxname=text]').textbox('getValue');
                    if (!text)
                        return;
                    var html = elementTextContentToHtml(text);
                    if (isInsertAction) {
                        insert({type: 'p', text: html});
                    } else {
                        $(updateElem).html(html);
                        sArtNodeIdMap[updateElem.id].data.text = text;
                    }
                    dialog.dialog('destroy');
                }
            });
            if (!isInsertAction) {
                dialog.find('[textboxname=text]').textbox('setValue', updateElem.innerText);
            }
        },
        img: function(isInsertAction, updateElem) {
            openUploadImageDialog({
                onSubmit: function() {
                    stateInfoBar.setInfo('正在上传图片...');
                },
                onSuccess: function(ret) {
                    if (!ret.url) return;
                    if (isInsertAction) {
                        insert({type: 'img', url: ret.url});
                    } else {
                        updateElem.src = ret.url;
                        sArtNodeIdMap[updateElem.id].data.url = ret.url;
                    }
                    stateInfoBar.clear();
                }
            });
        },
        video: function(isInsertAction, updateElem) {
            openUploadVideoDialog({
                onSubmit: function() {
                    stateInfoBar.setInfo('正在上传视频...');
                },
                onSuccess: function(ret) {
                    if (!ret.url) return;
                    if (isInsertAction) {
                        insert({type: 'video', url: ret.url});
                    } else {
                        updateElem.src = ret.url;
                        sArtNodeIdMap[updateElem.id].data.url = ret.url;
                    }
                    stateInfoBar.clear();
                }
            });
        }
    }

    function elementTextContentToHtml(text) {
        return text.replace(/\40/g, '&nbsp;&nbsp;').replace(/[\r\n]/g, '<br>');;
    }

    function Toolbar() {
        var toolbar = document.createElement('div');
        $(toolbar).addClass('s-article-editor-toolbar');
        toolbar.appendChild(new TitleButton());
        toolbar.appendChild(new PButton());
        toolbar.appendChild(new ImageButton());
        toolbar.appendChild(new VideoButton());
        toolbar.appendChild(new EditButton());
        toolbar.appendChild(new DeleteButton());
        toolbar.appendChild(new HelpButton());
        toolbar.appendChild(new SaveButton());
        return toolbar;

        function TitleButton() {
            return new Button({
                text: '标题',
                alt: '插入标题',
                onClick: function() {
                    ElementEditors.h1(true);
                }
            });
        }

        function PButton() {
            return new Button({
                text: '段落',
                alt: '插入段落',
                onClick: function() {
                    ElementEditors.p(true);
                }
            });
        }

        function ImageButton() {
            return new Button({
                text: '图片',
                alt: '插入图片',
                onClick: function() {
                    ElementEditors.img(true);
                }
            });
        }

        function VideoButton() {
            return new Button({
                text: '视频',
                alt: '插入视频',
                onClick: function() {
                    ElementEditors.video(true);
                }
            });
        }

        function DeleteButton() {
            return new Button({
                text: '删除',
                alt: '删除选中元素',
                css: {backgroundColor: '#f44336'},
                onClick: function() {
                    deleteSelectedElement();
                }
            });
        }

        function EditButton() {
            return new Button({
                text: '修改',
                alt: '修改选中元素',
                css: {backgroundColor: '#555555'},
                onClick: function() {
                    if (!selectedElement) {
                        alert('请先选中一个元素');
                        return;
                    }
                    var type = selectedElement.tagName.toLowerCase();
                    ElementEditors[type](false, selectedElement);
                }
            });
        }

        function HelpButton() {
            return new Button({
                text: '帮助',
                alt: '帮助和说明',
                css: {backgroundColor: '#888888'},
                onClick: function() {
                    alert('= 操作说明 =\n' +
                        '\n * 单击【图片】等元素插入按钮，往内容中插入元素；默认插入到末尾，如果选中了某个元素再单击插入按钮，则插入到选中元素之后。' +
                        '\n * 单击内容中的元素，切换该元素的选中状态。' +
                        '\n * 单击【删除】，删除选中元素。' +
                        '\n * 单击【修改】，修改选中元素的文本，或重新上传图片、视频。' +
                        '\n * 注意，暂不支持撤销功能。');
                }
            });
        }

        function SaveButton() {
            return new Button({
                text: '保存',
                alt: '保存',
                css: {backgroundColor: '#02b9e3', float: 'right'},
                onClick: function() {
                    if (options.onSave)
                        options.onSave.call(editor);
                }
            });
        }

        function Button(spec) {
            var button = document.createElement('button');
            button.innerText = spec.text;
            button.onclick = spec.onClick;
            button.title = spec.alt;
            if (spec.css) {
                $(button).css(spec.css);
            }
            return button;
        }
    }

    function StateInfoBar() {
        var bar = document.createElement('div');
        $(bar).addClass('s-article-editor-statebar');

        bar.setInfo = function(info) {
            bar.innerText = info;
        }

        bar.clear = function() {
            bar.innerText = '';
        }

        return bar;
    }

    var editor = document.createElement('div');
    document.getElementById(containerId).appendChild(editor);
    $(editor).addClass('s-article-editor');


    //工具栏
    var toolbar = new Toolbar();
    if (!options.previewMode) {
        editor.appendChild(toolbar);
    }

    //内容区
    var contentContainer = document.createElement('div');
    $(contentContainer).addClass('s-article-editor-content');
    $(contentContainer).width(options.width);
    $(contentContainer).height(options.height);
    editor.appendChild(contentContainer);

    //状态信息提示栏
    var stateInfoBar = new StateInfoBar();
    editor.appendChild(stateInfoBar);

    // sArt元素节点链表
    var headSArtElementListNode = {prev: null, next: null};
    var tailSArtElementListNode = headSArtElementListNode;
    // id->元素
    var sArtNodeIdMap = {};
    var id = 1;
    var selectedElement = null;
    var editor = this;

    function insert(sArtElement) {
        var newElem;
        if (selectedElement) {
            newElem = editor.insertAfter(sArtElement, selectedElement);
        } else {
            newElem = editor.append(sArtElement);
            $(contentContainer).scrollTop($(contentContainer).outerHeight());
        }
        setSelected(newElem);
        return newElem;
    }

    this.enterPreviewMode = function() {
        $(toolbar).hide();
    }

    /**
     * @param sArtElement {type, text|url}
     */
    this.append = function(sArtElement) {
        var appendListNode = {data: sArtElement, prev: null, next: null};
        appendListNode.prev = tailSArtElementListNode;
        tailSArtElementListNode.next = appendListNode;
        tailSArtElementListNode = appendListNode;

        var newElem = sArtElementToDomElement(sArtElement);
        newElem.id = id++;//分配一个id
        contentContainer.appendChild(newElem);
        sArtNodeIdMap[newElem.id] = appendListNode;

        return newElem;
    }

    this.insertAfter = function(sArtElement, existingDomElem) {
        var existingSArtElement = sArtNodeIdMap[existingDomElem.id];
        if (!existingSArtElement.next) {
            return this.append(sArtElement);
        } else {
            var insertListNode = {data: sArtElement, prev: null, next: null};
            insertListNode.next = existingSArtElement.next;
            existingSArtElement.next.prev = insertListNode;
            existingSArtElement.next = insertListNode;
            insertListNode.prev = existingSArtElement;

            var newElem = sArtElementToDomElement(sArtElement);
            $(newElem).insertAfter(existingDomElem);
            newElem.id = id++;
            sArtNodeIdMap[newElem.id] = insertListNode;
            return newElem;
        }
    }

    this.startLoadContent = function () {
        stateInfoBar.setInfo('加载内容中');
    }

    function deleteSelectedElement() {
        if (!selectedElement) {
            alert('请先选中一个元素');
            return;
        }
        deleteElement(selectedElement);
        selectedElement = null;
    }

    function deleteElement(existingDomElem) {
        var existingSArtElement = sArtNodeIdMap[existingDomElem.id];
        if (!existingSArtElement.next) {//最后一个
            existingSArtElement.prev.next = null;
            tailSArtElementListNode = existingSArtElement.prev;
        } else {
            existingSArtElement.prev.next = existingSArtElement.next;
            existingSArtElement.next.prev = existingSArtElement.prev;
        }
        contentContainer.removeChild(existingDomElem);
    }

    this.setValue = function(jsonValue) {
        id = 1;
        $(contentContainer).empty();
        stateInfoBar.clear();

        JSON.parse(jsonValue).forEach(function(el) {
            editor.append(el);
        });
    }

    this.clear = function() {
        $(contentContainer).empty();
        stateInfoBar.clear();
    }

    this.getSArtElements = function() {
        var arr = [];
        for (var iter = headSArtElementListNode.next; iter; iter = iter.next) {
            arr.push(iter.data);
        }
        return arr;
    }

    /**
     * 元素转到 将会渲染到编辑器内容里的DOM元素
     * @param sArtElement
     */
    function sArtElementToDomElement(sArtElement) {
        var creator = ElementCreators[sArtElement.type];
        if (!creator) {
            console.error('不支持元素类型:', sArtElement.type);
            return;
        }
        var domElement = creator(sArtElement);
        $(domElement).addClass('s-article-editor-element');
        domElement.selected = false;
        domElement.onclick = function() {
            if (!this.selected) {
                setSelected(this);
            } else {
                setUnSelected(this);
            }
        }
        return domElement;
    }


    function setSelected(elem) {
        //支持单选，其它设为不选
        $(contentContainer).find('.s-article-editor-element').each(function() {
            setUnSelected(this);
            selectedElement = null;
        });
        $(elem).addClass('s-article-editor-element-selected');
        elem.selected = true;
        selectedElement = elem;
    }
    function setUnSelected(elem) {
        $(elem).removeClass('s-article-editor-element-selected');
        elem.selected = false;
        selectedElement = null;
    }


    if (options.onReady) {
        setTimeout(options.onReady.bind(editor));
    }
}