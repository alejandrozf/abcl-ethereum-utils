# abcl-ethereum-utils
### _Alejandro Zamora <ale2014.zamora@gmail.com>_

Some Ethereum utility functions using ABCL + Web3J library (WIP)


## Use

Clone this repository to your Quicklisp local-projects folder:

```
CL-USER> (require :abcl-contrib)
NIL
CL-USER> (require :abcl-asdf)
("ABCL-ASDF")
CL-USER> (ql:quickload :abcl-ethereum-utils)
To load "abcl-ethereum-utils":
  Load 1 ASDF system:
    abcl-ethereum-utils
; Loading "abcl-ethereum-utils"
(:ABCL-ETHEREUM-UTILS)
CL-USER> (let ((abcl-ethereum-utils:*provider-url* "<YOUR-PROVIDER-URL>"))
           ;; Querying a DAI address
           ;;  if *provider-url* is NIL, it will assume "localhost/127.0.0.1:8545" is used
           (abcl-ethereum-utils:query-erc20 "0x6B175474E89094C44Da98b954EedeAC495271d0F" "0xAB8B68548Bd6431ca6AcEeB621e4D857bf5695e8"))
0.93817747 (93.81775%)
CL-USER>
```

## License

MIT
