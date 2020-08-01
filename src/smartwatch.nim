# example.nim
import
  htmlgen,
  jester,
  depman

routes:
  get "/":
    resp h1("Hello world")