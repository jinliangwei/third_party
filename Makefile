THIRD_PARTY_HOST = http://www.cs.cmu.edu/~jinlianw/third_party
THIRD_PARTY := $(shell readlink $(dir $(lastword $(MAKEFILE_LIST))) -f)
THIRD_PARTY_SRC := $(THIRD_PARTY)/src
THIRD_PARTY_LIB := $(THIRD_PARTY)/lib
THIRD_PARTY_BIN := $(THIRD_PARTY)/bin
THIRD_PARTY_SHARE := $(THIRD_PARTY)/share
THIRD_PARTY_INCLUDE := $(THIRD_PARTY)/include

third_party_core: path \
                  gflags \
                  glog \
                  gperftools \
                  cuckoo \
		  boost \
		  yaml-cpp \
                  snappy \
		  float16_compressor \
                  zeromq \
		  eigen \
                  leveldb

third_party_all: third_party_core \
                 sparsehash \
                 oprofile \
		 iftop \
		 rapidjson \
                 libconfig \
	          gtest \
		  llvm

path:
	mkdir -p $(THIRD_PARTY_SRC)
	mkdir -p $(THIRD_PARTY_LIB)
	mkdir -p $(THIRD_PARTY_INCLUDE)

clean:
	rm -rf $(THIRD_PARTY_SRC)
	rm -rf $(THIRD_PARTY_LIB)
	rm -rf $(THIRD_PARTY_BIN)
	rm -rf $(THIRD_PARTY_SHARE)
	rm -rf $(THIRD_PARTY_INCLUDE)

.PHONY: third_party_core third_party_all clean gflags

# ===================== gflags ===================

GFLAGS_SRC = $(THIRD_PARTY_SRC)/gflags-2.0.tar.gz
GFLAGS_LIB = $(THIRD_PARTY_LIB)/libgflags.so

gflags: $(GFLAGS_LIB)

$(GFLAGS_LIB): $(GFLAGS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

$(GFLAGS_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== glog =====================

GLOG_SRC = $(THIRD_PARTY_SRC)/glog-0.3.3.tar.gz
GLOG_LIB = $(THIRD_PARTY_LIB)/libglog.so

glog: $(GLOG_LIB)

$(GLOG_LIB): gflags $(GLOG_SRC)
	tar zxf $(GLOG_SRC) -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $(GLOG_SRC))); \
	./configure --prefix=$(THIRD_PARTY) --with-gflags=$(THIRD_PARTY); \
	make install

$(GLOG_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== gtest ====================

GTEST_SRC = $(THIRD_PARTY_SRC)/gtest-1.7.0.tar
GTEST_LIB = $(THIRD_PARTY_LIB)/libgtest.a

gtest: $(GTEST_LIB)

$(GTEST_LIB): $(GTEST_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $<)/make; \
	make gtest; \
	./sample1_unittest; \
	cp -r ../include/* $(THIRD_PARTY_INCLUDE)/; \
	cp gtest.a $@

$(GTEST_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ==================== zeromq ====================

ZMQ_SRC = $(THIRD_PARTY_SRC)/zeromq-3.2.3.tar.gz
ZMQ_LIB = $(THIRD_PARTY_LIB)/libzmq.so

zeromq: $(ZMQ_LIB)

$(ZMQ_LIB): $(ZMQ_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

$(ZMQ_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@
	wget $(THIRD_PARTY_HOST)/zmq.hpp -P $(THIRD_PARTY_INCLUDE)

# ==================== boost ====================

BOOST_SRC = $(THIRD_PARTY_SRC)/boost_1_59_0.tar.gz
BOOST_INCLUDE = $(THIRD_PARTY_INCLUDE)/boost

boost: $(BOOST_INCLUDE)

$(BOOST_INCLUDE): $(BOOST_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(THIRD_PARTY_SRC)/boost_1_59_0/; \
	./bootstrap.sh --with-libraries=system,thread --prefix=$(THIRD_PARTY); \
	./b2 install

$(BOOST_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ================== gperftools =================

GPERFTOOLS_SRC = $(THIRD_PARTY_SRC)/gperftools-2.1.tar.gz
GPERFTOOLS_LIB = $(THIRD_PARTY_LIB)/libtcmalloc.so

gperftools: $(GPERFTOOLS_LIB)

$(GPERFTOOLS_LIB): $(GPERFTOOLS_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY) --enable-frame-pointers; \
	make install

$(GPERFTOOLS_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== libcuckoo =====================

CUCKOO_SRC = $(THIRD_PARTY_SRC)/libcuckoo.tar
CUCKOO_INCLUDE = $(THIRD_PARTY_INCLUDE)/libcuckoo

cuckoo: $(CUCKOO_INCLUDE)

$(CUCKOO_INCLUDE): $(CUCKOO_SRC)
	tar xf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	autoreconf -fis; \
	./configure --prefix=$(THIRD_PARTY); \
	make; make install

$(CUCKOO_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@
#
# =================== oprofile ===================
# NOTE: need libpopt-dev binutils-dev

OPROFILE_SRC = $(THIRD_PARTY_SRC)/oprofile-0.9.9.tar.gz
OPROFILE_LIB = $(THIRD_PARTY_LIB)/oprofile

oprofile: $(OPROFILE_LIB)

$(OPROFILE_LIB): $(OPROFILE_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

$(OPROFILE_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ================== sparsehash ==================

SPARSEHASH_SRC = $(THIRD_PARTY_SRC)/sparsehash-2.0.2.tar.gz
SPARSEHASH_INCLUDE = $(THIRD_PARTY_INCLUDE)/sparsehash

sparsehash: $(SPARSEHASH_INCLUDE)

$(SPARSEHASH_INCLUDE): $(SPARSEHASH_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

$(SPARSEHASH_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ================== iftop ==================

IFTOP_SRC = $(THIRD_PARTY_SRC)/iftop-1.0pre4.tar.gz
IFTOP_BIN = $(THIRD_PARTY_BIN)/iftop

iftop: $(IFTOP_BIN)

$(IFTOP_BIN): $(IFTOP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install; \
	cp iftop $(IFTOP_BIN)

$(IFTOP_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@


# ==================== libconfig ===================

LIBCONFIG_SRC = $(THIRD_PARTY_SRC)/libconfig-1.4.9.tar.gz
LIBCONFIG_LIB = $(THIRD_PARTY_LIB)/libconfig++.so

libconfig: $(LIBCONFIG_LIB)

$(LIBCONFIG_LIB): $(LIBCONFIG_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

$(LIBCONFIG_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ==================== yaml-cpp ===================

YAMLCPP_SRC = $(THIRD_PARTY_SRC)/yaml-cpp-0.5.1.tar.gz
YAMLCPP_MK = $(THIRD_PARTY_SRC)/yaml-cpp.mk
YAMLCPP_LIB = $(THIRD_PARTY_LIB)/libyaml-cpp.a

yaml-cpp: boost $(YAMLCPP_LIB)

$(YAMLCPP_LIB): $(YAMLCPP_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	make -f $(YAMLCPP_MK) BOOST_PREFIX=$(THIRD_PARTY) TARGET=$@; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

$(YAMLCPP_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@
	wget $(THIRD_PARTY_HOST)/$(notdir $(YAMLCPP_MK)) -P $(THIRD_PARTY_SRC)

# ==================== leveldb ===================

LEVELDB_SRC = $(THIRD_PARTY_SRC)/leveldb-1.15.0.tar.gz
LEVELDB_LIB = $(THIRD_PARTY_LIB)/libleveldb.so

leveldb: $(LEVELDB_LIB)

$(LEVELDB_LIB): $(LEVELDB_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	LIBRARY_PATH=$(THIRD_PARTY_LIB):${LIBRARY_PATH} \
	make; \
	cp ./libleveldb.* $(THIRD_PARTY_LIB)/; \
	cp -r include/* $(THIRD_PARTY_INCLUDE)/

$(LEVELDB_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ==================== snappy ===================


SNAPPY_SRC = $(THIRD_PARTY_SRC)/snappy-1.1.2.tar.gz
SNAPPY_LIB = $(THIRD_PARTY_LIB)/libsnappy.so

snappy: $(SNAPPY_LIB)

$(SNAPPY_LIB): $(SNAPPY_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cd $(basename $(basename $<)); \
	./configure --prefix=$(THIRD_PARTY); \
	make install

# TODO(wdai): Make sure the file is actually hosted.
$(SNAPPY_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== eigen =====================

EIGEN_SRC = $(THIRD_PARTY_SRC)/eigen.3.2.4.tar.gz
EIGEN_INCLUDE = $(THIRD_PARTY_INCLUDE)/Eigen

eigen: $(EIGEN_INCLUDE)

$(EIGEN_INCLUDE): $(EIGEN_SRC)
	tar zxf $< -C $(THIRD_PARTY_SRC)
	cp -r $(THIRD_PARTY_SRC)/eigen-eigen-10219c95fe65/Eigen $(THIRD_PARTY_INCLUDE)/

$(EIGEN_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== float16_compressor =====================
FLOAT16_COMPRESSOR_SRC = $(THIRD_PARTY_SRC)/float16_compressor.hpp
FLOAT16_COMPRESSOR_INCLUDE = $(THIRD_PARTY_INCLUDE)/float16_compressor.hpp

float16_compressor: $(FLOAT16_COMPRESSOR_INCLUDE)

$(FLOAT16_COMPRESSOR_INCLUDE): $(FLOAT16_COMPRESSOR_SRC)
	cp $(FLOAT16_COMPRESSOR_SRC) $(THIRD_PARTY_INCLUDE)/

$(FLOAT16_COMPRESSOR_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== RapidJson =====================
RAPID_JSON_SRC = $(THIRD_PARTY_SRC)/rapidjson.tar.gz
RAPID_JSON_INCLUDE = $(THIRD_PARTY_INCLUDE)/rapidjson

rapid_json: $(RAPID_JSON_INCLUDE)

$(RAPID_JSON_INCLUDE): $(RAPID_JSON_SRC)
	tar xzf $< -C $(THIRD_PARTY_SRC)
	cp -r $(THIRD_PARTY_SRC)/rapidjson/include/rapidjson $(THIRD_PARTY_INCLUDE)/

$(RAPID_JSON_SRC):
	wget $(THIRD_PARTY_HOST)/$(@F) -O $@

# ===================== LLVM =====================
LLVM3.7.1_SRC = $(THIRD_PARTY_SRC)/llvm-3.7.1.src.tar.xz
LLVM3.7.1_INCLUDE = $(THIRD_PARTY_INCLUDE)/llvm

llvm: $(LLVM3.7.1_INCLUDE)

$(LLVM3.7.1_INCLUDE): $(LLVM3.7.1_SRC)
	tar xJf $< -C $(THIRD_PARTY_SRC)
	mkdir -p $(THIRD_PARTY_SRC)/llvm3.7.1
	cd $(THIRD_PARTY_SRC)/llvm3.7.1; \
	cmake $(THIRD_PARTY_SRC)/llvm-3.7.1.src; \
	cmake --build .
	cp -r $(THIRD_PARTY_SRC)/llvm-3.7.1.src/include/llvm $(THIRD_PARTY_INCLUDE)/
	cp -r $(THIRD_PARTY_SRC)/llvm-3.7.1.src/include/llvm-c $(THIRD_PARTY_INCLUDE)/
	cp -r $(THIRD_PARTY_SRC)/llvm3.7.1/include/llvm/* $(THIRD_PARTY_INCLUDE)/llvm
	cp -r $(THIRD_PARTY_SRC)/llvm3.7.1/lib/* $(THIRD_PARTY_LIB)/
	cp -r $(THIRD_PARTY_SRC)/llvm3.7.1/bin/* $(THIRD_PARTY_BIN)/

$(LLVM3.7.1_SRC):
	wget http://llvm.org/releases/3.7.1/llvm-3.7.1.src.tar.xz -O $@
