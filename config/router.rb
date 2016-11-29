Boto.router.draw do
  listen //, to: "Welcome#log"

  listen "start", to: "Welcome#hello"
  listen "hello", to: "Welcome#hello"

  listen "echo", to: "Welcome#echo"
  listen "repeat", to: "Welcome#echo"
end
