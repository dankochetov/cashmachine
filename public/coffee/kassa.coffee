kassa = angular.module 'kassa', ['ui.bootstrap']
kassa.controller 'mainCtrl', ($scope, $rootScope, $uibModal, $http, $q, $timeout)->
  dbInit = $q.defer()
  users = products = null
  $http.get('/api/users').then (res)->
    users = res.data
    $http.get('/api/products').then (res)->
      products = res.data
      dbInit.resolve()

  $scope.removeModeTitle = 'Режим удаления'
  $rootScope.allowAdding = true
  authInit = $q.defer()
  $scope.removeMode = false
  $scope.list = []
  $scope.authSuccess = false

  createModal = ->
    modal = $uibModal.open
      size: 'sm'
      templateUrl: 'auth'
      controller: 'modalAuthCtrl'
      backdrop: 'static'
      keyboard: false
    modal.result.then (data)->
      f = on
      for i of users
        if users[i].login is data.login and users[i].pwd is data.pwd
          f = off
          authInit.resolve()
          break
      if f
        createModal()
      else
        $scope.authSuccess = true

  dbInit.promise.then createModal

  addProduct = ->
    i = Math.round Math.random() * (products.length - 1)
    name = products[i].name
    mass = Math.random() * 9 + 1
    price = products[i].price
    cost = mass * price
    f = off
    for i of $scope.list
      if $scope.list[i].name is name
        f = on
        ind = i
        break
    $timeout ->
      if f
        $scope.list[ind].mass += mass
        $scope.list[ind].cost = $scope.list[ind].mass * $scope.list[ind].price
      else
        $scope.list.push
          name: name
          mass: mass
          price: price
          cost: cost
          selected: false

    $timeout -> $('body')[0].scrollTop = $('body')[0].scrollHeight

  authInit.promise.then ->
    $(document).keypress (e)->
      if e.which == 13 or not $rootScope.allowAdding then addProduct()

  $scope.total = ->
    res = 0
    for i of $scope.list
      res += parseFloat($scope.list[i].cost.toFixed(2))
    if $scope.discount then res *= 0.97
    res.toFixed 2

  $scope.switchRemoveMode = ->
    $scope.removeMode = not $scope.removeMode
    if $scope.removeMode
      $scope.removeModeTitle = 'Отмена'
    else
      $scope.removeModeTitle = 'Режим удаления'
    $rootScope.allowAdding = not $rootScope.allowAdding

  $scope.removeSelected = ->
    $scope.list = $scope.list.filter (item)-> not item.selected
    $scope.switchRemoveMode()
    $rootScope.allowAdding = true

  $scope.print = ->
    if $scope.list.length is 0
      alert 'Сначала добавьте продукты!'
      return
    $rootScope.allowAdding = off
    modal = $uibModal.open(
      size: 'sm'
      templateUrl: 'print'
      controller: 'modalPrintCtrl'
      backdrop: 'static'
      keyboard: off
      resolve:
        list: -> $scope.list
        total: -> $scope.total()
    )
    modal.result.then ->
      $scope.list = []
      $rootScope.allowAdding = on

kassa.controller 'modalAuthCtrl', ($scope, $uibModalInstance)->
  $scope.login = ''
  $scope.pwd = ''

  $scope.ok = ->
    $uibModalInstance.close
      login: $scope.login
      pwd: $scope.pwd

kassa.controller 'modalPrintCtrl', ($scope, $uibModalInstance, list, total)->
  $scope.list = list
  $scope.total = total
  $scope.date = Date.now()

  $scope.ok = -> $uibModalInstance.close()