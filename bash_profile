#homebrew stuff
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

#golang stuff
export GOPATH=/Users/Jeff/code/go
export PATH=$GOPATH/bin:$PATH

function pf
{
  ps -efw | grep $1 | grep -v grep


}

function pfk
{

  pf $1 | awk '{print $2}' | xargs kill

}