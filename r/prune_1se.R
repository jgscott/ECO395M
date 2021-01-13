# pruning an rpart tree
# this function finds the complexity parameter
# within 1 std error of the minimum CV error
cp_1se = function(my_tree) {
  require(rpart)
  out = as.data.frame(my_tree$cptable)
  thresh = min(out$xerror + out$xstd)
  cp_opt = max(out$CP[out$xerror <= thresh])
  cp_opt
}

# this function actually prunes the tree at that 1se level
prune_1se = function(my_tree) {
  require(rpart)
  out = as.data.frame(my_tree$cptable)
  thresh = min(out$xerror + out$xstd)
  cp_opt = max(out$CP[out$xerror <= thresh])
  prune(my_tree, cp=cp_opt)
}
