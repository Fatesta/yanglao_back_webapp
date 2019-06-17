<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .home-header {
	    background: ${designStyle.colors.dominant});
    }
    .head-menu-button-active {
       color: white;
    }
    .big-menu-item .menu-text {
       font-size: 14px;
    }
    

	/*validatebox*/
	.easyui-validatebox:hover, .textbox-focused, .textbox:hover {
	    border-color: ${designStyle.colors.dominant};
	}
	
    textarea:focus, input:focus {
        border-color: ${designStyle.colors.dominant}
    }
    .tree-node-selected, .combobox-item-selected, .datagrid-row-selected, .accordion .accordion-header-selected {
        background: rgb(160, 207, 255) !important;
        
    }
    .accordion .accordion-header-selected .panel-title {
        color: #fff !important;
    }
    
    .menu-active, div.tip_title {
        background: ${designStyle.colors.dominant};
    }
    .easyui-menu {
        box-shadow: 1px 1px 10px;
        border-radius: 2px;
    }
    .window .dialog-button .l-btn>span {
        background-color: ${designStyle.colors.dominant};
    }

</style>
