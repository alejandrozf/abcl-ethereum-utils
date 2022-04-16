;;;; abcl-ethereum-utils.lisp

(in-package #:abcl-ethereum-utils)

(let* ((core-deps (abcl-asdf:resolve-dependencies "org.web3j"
                                                  "core"
                                                  :version "4.8.7"))
       (contracts-deps (abcl-asdf:resolve-dependencies "org.web3j"
                                                       "contracts"
                                                       :version "4.8.7"))
       (all-jar-paths (append (abcl-asdf:as-classpath core-deps)
                              (abcl-asdf:as-classpath contracts-deps))))
  (java:add-to-classpath all-jar-paths))

(defparameter *provider-url* nil)

(defun query-erc20 (erc20-contract-address target-address &key (exact-value t))
  (let* ((build-method (load-time-value (java:jmethod "org.web3j.protocol.Web3j" "build" "org.web3j.protocol.Web3jService")))
         (service-instance (if *provider-url*
                               (java:jnew "org.web3j.protocol.http.HttpService" *provider-url*)
                               (java:jnew "org.web3j.protocol.http.HttpService")))
         (web3j-instance (java:jstatic build-method "org.web3j.protocol.Web3j" service-instance))
         (transaction-manager (java:jnew "org.web3j.tx.ReadonlyTransactionManager" web3j-instance erc20-contract-address))
         (load-method (load-time-value
                       (java:jmethod "org.web3j.contracts.eip20.generated.ERC20"
                                "load" "java.lang.String" "org.web3j.protocol.Web3j" "org.web3j.tx.TransactionManager"
                                "org.web3j.tx.gas.ContractGasProvider")))
         (gas-provider (load-time-value (java:jnew "org.web3j.tx.gas.DefaultGasProvider")))
         (erc20-contract-instance (java:jstatic load-method "org.web3j.contracts.eip20.generated.ERC20" erc20-contract-address
                                                web3j-instance transaction-manager gas-provider))
         (balance-of-method (load-time-value
                             (java:jmethod "org.web3j.contracts.eip20.generated.ERC20" "balanceOf" "java.lang.String")))
         (remote-call-balance-of-instance (java:jcall balance-of-method erc20-contract-instance target-address))
         (send-method (load-time-value (java:jmethod "org.web3j.protocol.core.RemoteFunctionCall" "send"))))

    (let ((18-decimals-value (java:jcall send-method remote-call-balance-of-instance)))
      (if exact-value
          (/ 18-decimals-value #.(float (expt 10 18)))
          18-decimals-value))))
