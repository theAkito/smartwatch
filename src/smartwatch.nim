# example.nim
import
  htmlgen,
  jester

routes:
  get "/":
    resp h1("Hello world")