import Vue from 'vue';
import DataTable from './DataTable.vue';
import TypeSelect from './TypeSelect.vue';
import DataTableQueryButton from './DataTableQueryButton.vue';
import DataTableAppView from './DataTableAppView.vue';
import EmptyButton from './EmptyButton.vue';
import CardPage from './page/CardPage.vue';
import PlainPage from './page/PlainPage.vue';
import DataTableAppPage from './page/DataTableAppPage.vue';

// 这些组件很常用，为方便使用和性能，应打包为initial chunk
Vue.component(CardPage.name, CardPage);
Vue.component(PlainPage.name, PlainPage);
Vue.component(DataTable.name, DataTable);
Vue.component(TypeSelect.name, TypeSelect);
Vue.component(DataTableQueryButton.name, DataTableQueryButton);
Vue.component(DataTableAppView.name, DataTableAppView);
Vue.component(DataTableAppPage.name, DataTableAppPage);
Vue.component(EmptyButton.name, EmptyButton);