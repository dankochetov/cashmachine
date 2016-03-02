var kassa;

kassa = angular.module('kassa', ['ui.bootstrap']);

kassa.controller('mainCtrl', function($scope, $rootScope, $uibModal, $http, $q, $timeout) {
  var addProduct, authInit, createModal, dbInit, products, users;
  dbInit = $q.defer();
  users = products = null;
  $http.get('/api/users').then(function(res) {
    users = res.data;
    return $http.get('/api/products').then(function(res) {
      products = res.data;
      return dbInit.resolve();
    });
  });
  $scope.removeModeTitle = 'Режим удаления';
  $rootScope.allowAdding = true;
  authInit = $q.defer();
  $scope.removeMode = false;
  $scope.list = [];
  $scope.authSuccess = false;
  createModal = function() {
    var modal;
    modal = $uibModal.open({
      size: 'sm',
      templateUrl: 'auth',
      controller: 'modalAuthCtrl',
      backdrop: 'static',
      keyboard: false
    });
    return modal.result.then(function(data) {
      var f, i;
      f = true;
      for (i in users) {
        if (users[i].login === data.login && users[i].pwd === data.pwd) {
          f = false;
          authInit.resolve();
          break;
        }
      }
      if (f) {
        return createModal();
      } else {
        return $scope.authSuccess = true;
      }
    });
  };
  dbInit.promise.then(createModal);
  addProduct = function() {
    var cost, f, i, ind, mass, name, price;
    i = Math.round(Math.random() * (products.length - 1));
    name = products[i].name;
    mass = Math.random() * 9 + 1;
    price = products[i].price;
    cost = mass * price;
    f = false;
    for (i in $scope.list) {
      if ($scope.list[i].name === name) {
        f = true;
        ind = i;
        break;
      }
    }
    $timeout(function() {
      if (f) {
        $scope.list[ind].mass += mass;
        return $scope.list[ind].cost = $scope.list[ind].mass * $scope.list[ind].price;
      } else {
        return $scope.list.push({
          name: name,
          mass: mass,
          price: price,
          cost: cost,
          selected: false
        });
      }
    });
    return $timeout(function() {
      return $('body')[0].scrollTop = $('body')[0].scrollHeight;
    });
  };
  authInit.promise.then(function() {
    return $(document).keypress(function(e) {
      if (e.which === 13 || !$rootScope.allowAdding) {
        return addProduct();
      }
    });
  });
  $scope.total = function() {
    var i, res;
    res = 0;
    for (i in $scope.list) {
      res += parseFloat($scope.list[i].cost.toFixed(2));
    }
    if ($scope.discount) {
      res *= 0.97;
    }
    return res.toFixed(2);
  };
  $scope.switchRemoveMode = function() {
    $scope.removeMode = !$scope.removeMode;
    if ($scope.removeMode) {
      $scope.removeModeTitle = 'Отмена';
    } else {
      $scope.removeModeTitle = 'Режим удаления';
    }
    return $rootScope.allowAdding = !$rootScope.allowAdding;
  };
  $scope.removeSelected = function() {
    $scope.list = $scope.list.filter(function(item) {
      return !item.selected;
    });
    $scope.switchRemoveMode();
    return $rootScope.allowAdding = true;
  };
  return $scope.print = function() {
    var modal;
    if ($scope.list.length === 0) {
      alert('Сначала добавьте продукты!');
      return;
    }
    $rootScope.allowAdding = false;
    modal = $uibModal.open({
      size: 'sm',
      templateUrl: 'print',
      controller: 'modalPrintCtrl',
      backdrop: 'static',
      keyboard: false,
      resolve: {
        list: function() {
          return $scope.list;
        },
        total: function() {
          return $scope.total();
        }
      }
    });
    return modal.result.then(function() {
      $scope.list = [];
      return $rootScope.allowAdding = true;
    });
  };
});

kassa.controller('modalAuthCtrl', function($scope, $uibModalInstance) {
  $scope.login = '';
  $scope.pwd = '';
  return $scope.ok = function() {
    return $uibModalInstance.close({
      login: $scope.login,
      pwd: $scope.pwd
    });
  };
});

kassa.controller('modalPrintCtrl', function($scope, $uibModalInstance, list, total) {
  $scope.list = list;
  $scope.total = total;
  $scope.date = Date.now();
  return $scope.ok = function() {
    return $uibModalInstance.close();
  };
});
