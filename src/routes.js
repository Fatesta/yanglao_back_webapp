export default [
  // 用户
  {
    path: '/user/index',
    title: '用户管理',
    component: () => import('@/pages/user/index')
  },
  {
    path: '/user/edit/index',
    title: '编辑用户',
    component: () => import('@/pages/user/edit/index')
  },
  {
    path: '/user/renzheng/index',
    title: '用户认证',
    component: () => import('@/pages/user/renzheng/index')
  },

  // 店铺
  {
    path: '/shop/shop/index',
    title: '店铺管理',
    component: () => import('@/pages/shop/shop/index')
  },
  {
    path: '/shop/shop/edit/index',
    title: '编辑店铺',
    component: () => import('@/pages/shop/shop/edit/index')
  },
  

  // 商家
  {
    path: '/shop/boss/index',
    title: '商家管理',
    component: () => import('@/pages/shop/boss/index')
  },
  {
    path: '/shop/boss/edit/index',
    title: '编辑商家',
    component: () => import('@/pages/shop/boss/edit/index')
  },
  {
    path: '/shop/finance/trade/index',
    title: '交易流水',
    component: () => import('@/pages/shop/finance/trade/index')
  },

  // 订单
  {
    path: '/shop/order/index',
    title: '订单管理',
    component: () => import('@/pages/shop/order/index')
  },
  {
    path: '/shop/order/flow/place/index',
    title: '下单',
    component: () => import('@/pages/shop/order/flow/place/index')
  },

  {
    path: '/shop/order/service/index',
    title: '服务工单',
    component: () => import('@/pages/shop/order/service/index')
  },
  {
    path: '/app/settings/index',
    title: '设置',
    component: () => import('@/pages/app/settings/index')
  }
]