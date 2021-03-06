context("Features: GCM")

test_that("GCM features are computed", {
  feat.object = createFeatureObject(iris[, -5], objective = "Petal.Width", blocks = 5)
  features = calculateFeatureSet(feat.object, "gcm")

  # check feature list
  expect_list(features)
  expect_identical(length(features), 75L)

  # use only 2 approaches
  features1 = calculateFeatureSet(feat.object, "gcm",
    control = list(gcm.approaches = c("min", "near")))
  expect_list(features1)
  expect_identical(length(features1), 50L)

  features2 = calculateFeatureSet(feat.object, "gcm",
    control = list(gcm.cf_power = 512L))
  expect_list(features2)
  expect_identical(length(features2), 75L)
  expect_identical(features[!grepl("costs_", names(features))],
    features[!grepl("costs_", names(features2))])
})

test_that("GCM features cannot compute on non-cellmapping object", {
  set.seed(2015*03*25)
  X = t(replicate(5000, runif(2, -1000, 1000)))
  y = apply(X, 1, function(x) {sum(x^2)})
  feat.object = createFeatureObject(X = X, y = y, 
    lower = -1000, upper = 1000)  
  
  # execution
  expect_error( calculateFeatureSet(feat.object, "gcm") )
})

test_that("Show Error", {
  set.seed(2015*03*26)
  
  # (1) create a feature object:
  X = expand.grid(1:4, 1:3)
  y = c(1, 1, 3, 2, 1, 1, 4, 2.5, 1.5, 2.5, 3.5, 0)
  feat.object = createFeatureObject(X = X, y = y, blocks = c(4, 3),
    lower = c(0.5, 0.5), upper = c(4.5, 3.5))
  
  expect_error(calculateFeatureSet(feat.object, "gcm",
    control = list(allow_cellmapping = FALSE)))
  feat.object = createFeatureObject(X = X, y = y,
    lower = c(0.5, 0.5), upper = c(4.5, 3.5))
  expect_error(calculateFeatureSet(feat.object, "gcm"))
})
