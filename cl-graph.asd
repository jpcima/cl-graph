;;; -*- Mode: Lisp; package: CL-USER; Syntax: Common-lisp; Base: 10 -*-

#|

|#

(in-package :common-lisp-user)
(defpackage "ASDF-CL-GRAPH" (:use #:cl #:asdf))
(in-package "ASDF-CL-GRAPH")

(unless (find-system 'asdf-system-connections nil)
 (when (find-package 'asdf-install)
   (print "Trying to install asdf-system-connections with ASDF-Install...")
   (funcall (intern "INSTALL" "ASDF-INSTALL") 'asdf-system-connections)))
;; give up with a useful (?) error message
(unless (find-system 'asdf-system-connections nil)
  (error "The CL-Graph system requires ASDF-SYSTEM-CONNECTIONS. See 
http://www.cliki.net/asdf-system-connections for details and download
instructions."))

(asdf:operate 'asdf:load-op 'asdf-system-connections)

(defsystem cl-graph
  :version "0.8"
  :author "Gary Warren King <gwking@metabang.com>"
  :maintainer "Gary Warren King <gwking@metabang.com>"
  :licence "MIT Style License"
  :description "Graph manipulation utilities for Common Lisp"
  :components ((:module "dev"
                        :components ((:file "package")
                                     (:file "api"
                                            :depends-on ("package"))
                                     (:file "macros"
                                            :depends-on ("package"))
                                     (:file "graph"
                                            :depends-on ("api"))
                                     (:file "graph-container"
                                            :depends-on ("graph"))
                                     (:file "graph-matrix"
                                            :depends-on ("graph"))
                                     (:file "graph-metrics"
                                            :depends-on ("graph"))
                                     (:file "graph-algorithms"
                                            :depends-on ("graph"))
                                     
                                     (:static-file "notes.text")

                                     (:module "graphviz" :depends-on ("graph")
                                              :components ((:file "graphviz-support")))))
               (:module "website"
                        :components ((:module "source"
                                              :components ((:static-file "index.lml"))))))
  
  :depends-on (metatilities 
               cl-containers
               metabang-bind
               cl-mathstats
               asdf-system-connections          ; makes ASDF-Install get this automatically
               ))

;;; ---------------------------------------------------------------------------

(asdf:defsystem-connection cl-graph-and-cl-variates
  :requires (cl-graph cl-variates)
  :components ((:module "dev"
                        :components ((:file "graph-and-variates")
                                     (:file "graph-generation"
                                            :depends-on ("graph-and-variates"))))))

(asdf:defsystem-connection cl-graph-and-cl-graphviz
  :requires (cl-graph cl-graphviz)
  :components ((:module "dev"
                        :components
                        ((:module "graphviz"
                                  :components
                                  ((:file "graphviz-support-optional")))))))
