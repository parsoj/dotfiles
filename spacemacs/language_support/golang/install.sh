# install go itself
sudo apt -y install install go

# tools for spacemacs go layer
go get -u -v golang.org/x/tools/cmd/godoc
go get -u -v github.com/nsf/gocode
go get -u -v github.com/rogpeppe/godef
go get -u -v golang.org/x/tools/cmd/guru
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v golang.org/x/tools/cmd/goimports

# install gometalinter
go get -u -v github.com/alecthomas/gometalinter
gometalinter --install --update
