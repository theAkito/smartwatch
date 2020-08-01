# example.nim
import
  htmlgen,
  jester,
  depman

routes:
  get "/":
    resp "Failure"