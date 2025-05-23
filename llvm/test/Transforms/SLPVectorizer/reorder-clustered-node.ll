; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: %if x86-registered-target %{ opt -passes=slp-vectorizer -S < %s -mtriple=x86_64 -slp-threshold=-150 | FileCheck %s --check-prefix X86 %}
; RUN: %if aarch64-registered-target %{ opt -passes=slp-vectorizer -S < %s -mtriple=aarch64-unknown-linux-gnu -slp-threshold=-150 | FileCheck %s --check-prefix AARCH64 %}

define i1 @test(ptr %arg, ptr %i233, i64 %i241, ptr %i235, ptr %i237, ptr %i227) {
; X86-LABEL: @test(
; X86-NEXT:  bb:
; X86-NEXT:    [[I226:%.*]] = getelementptr ptr, ptr [[ARG:%.*]], i32 7
; X86-NEXT:    [[I242:%.*]] = getelementptr double, ptr [[I233:%.*]], i64 [[I241:%.*]]
; X86-NEXT:    [[I245:%.*]] = getelementptr double, ptr [[I235:%.*]], i64 [[I241]]
; X86-NEXT:    [[I248:%.*]] = getelementptr double, ptr [[I237:%.*]], i64 [[I241]]
; X86-NEXT:    [[I250:%.*]] = getelementptr double, ptr [[I227:%.*]], i64 [[I241]]
; X86-NEXT:    [[TMP0:%.*]] = load <4 x ptr>, ptr [[I226]], align 8
; X86-NEXT:    [[TMP1:%.*]] = shufflevector <4 x ptr> [[TMP0]], <4 x ptr> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
; X86-NEXT:    [[TMP2:%.*]] = insertelement <8 x ptr> <ptr poison, ptr null, ptr poison, ptr null, ptr null, ptr null, ptr null, ptr null>, ptr [[I242]], i32 0
; X86-NEXT:    [[TMP3:%.*]] = insertelement <8 x ptr> [[TMP2]], ptr [[I250]], i32 2
; X86-NEXT:    [[TMP4:%.*]] = icmp ult <8 x ptr> [[TMP3]], [[TMP1]]
; X86-NEXT:    [[TMP5:%.*]] = insertelement <8 x ptr> poison, ptr [[I250]], i32 0
; X86-NEXT:    [[TMP6:%.*]] = insertelement <8 x ptr> [[TMP5]], ptr [[I242]], i32 1
; X86-NEXT:    [[TMP7:%.*]] = insertelement <8 x ptr> [[TMP6]], ptr [[I245]], i32 2
; X86-NEXT:    [[TMP8:%.*]] = insertelement <8 x ptr> [[TMP7]], ptr [[I248]], i32 3
; X86-NEXT:    [[TMP9:%.*]] = shufflevector <8 x ptr> [[TMP8]], <8 x ptr> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
; X86-NEXT:    [[TMP10:%.*]] = shufflevector <8 x ptr> [[TMP1]], <8 x ptr> <ptr poison, ptr null, ptr poison, ptr null, ptr null, ptr null, ptr null, ptr null>, <8 x i32> <i32 1, i32 9, i32 0, i32 11, i32 12, i32 13, i32 14, i32 15>
; X86-NEXT:    [[TMP11:%.*]] = icmp ult <8 x ptr> [[TMP9]], [[TMP10]]
; X86-NEXT:    [[TMP12:%.*]] = or <8 x i1> [[TMP4]], [[TMP11]]
; X86-NEXT:    [[TMP13:%.*]] = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> [[TMP12]])
; X86-NEXT:    [[OP_RDX:%.*]] = and i1 [[TMP13]], false
; X86-NEXT:    ret i1 [[OP_RDX]]
;
; AARCH64-LABEL: @test(
; AARCH64-NEXT:  bb:
; AARCH64-NEXT:    [[I226:%.*]] = getelementptr ptr, ptr [[ARG:%.*]], i32 7
; AARCH64-NEXT:    [[I242:%.*]] = getelementptr double, ptr [[I233:%.*]], i64 [[I241:%.*]]
; AARCH64-NEXT:    [[I245:%.*]] = getelementptr double, ptr [[I235:%.*]], i64 [[I241]]
; AARCH64-NEXT:    [[I248:%.*]] = getelementptr double, ptr [[I237:%.*]], i64 [[I241]]
; AARCH64-NEXT:    [[I250:%.*]] = getelementptr double, ptr [[I227:%.*]], i64 [[I241]]
; AARCH64-NEXT:    [[TMP0:%.*]] = load <4 x ptr>, ptr [[I226]], align 8
; AARCH64-NEXT:    [[TMP1:%.*]] = shufflevector <4 x ptr> [[TMP0]], <4 x ptr> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
; AARCH64-NEXT:    [[TMP2:%.*]] = insertelement <8 x ptr> <ptr poison, ptr null, ptr poison, ptr null, ptr null, ptr null, ptr null, ptr null>, ptr [[I242]], i32 0
; AARCH64-NEXT:    [[TMP3:%.*]] = insertelement <8 x ptr> [[TMP2]], ptr [[I250]], i32 2
; AARCH64-NEXT:    [[TMP4:%.*]] = icmp ult <8 x ptr> [[TMP3]], [[TMP1]]
; AARCH64-NEXT:    [[TMP5:%.*]] = shufflevector <8 x ptr> [[TMP3]], <8 x ptr> poison, <4 x i32> <i32 2, i32 0, i32 poison, i32 poison>
; AARCH64-NEXT:    [[TMP6:%.*]] = insertelement <4 x ptr> [[TMP5]], ptr [[I245]], i32 2
; AARCH64-NEXT:    [[TMP7:%.*]] = insertelement <4 x ptr> [[TMP6]], ptr [[I248]], i32 3
; AARCH64-NEXT:    [[TMP8:%.*]] = shufflevector <4 x ptr> [[TMP7]], <4 x ptr> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>
; AARCH64-NEXT:    [[TMP9:%.*]] = shufflevector <8 x ptr> [[TMP1]], <8 x ptr> <ptr poison, ptr null, ptr poison, ptr null, ptr null, ptr null, ptr null, ptr null>, <8 x i32> <i32 1, i32 9, i32 0, i32 11, i32 12, i32 13, i32 14, i32 15>
; AARCH64-NEXT:    [[TMP10:%.*]] = icmp ult <8 x ptr> [[TMP8]], [[TMP9]]
; AARCH64-NEXT:    [[TMP11:%.*]] = or <8 x i1> [[TMP4]], [[TMP10]]
; AARCH64-NEXT:    [[TMP12:%.*]] = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> [[TMP11]])
; AARCH64-NEXT:    [[OP_RDX:%.*]] = and i1 [[TMP12]], false
; AARCH64-NEXT:    ret i1 [[OP_RDX]]
;
bb:
  %i226 = getelementptr ptr, ptr %arg, i32 7
  %i2271 = load ptr, ptr %i226, align 8
  %i232 = getelementptr ptr, ptr %arg, i32 8
  %i2332 = load ptr, ptr %i232, align 8
  %i234 = getelementptr ptr, ptr %arg, i32 9
  %i2353 = load ptr, ptr %i234, align 8
  %i236 = getelementptr ptr, ptr %arg, i32 10
  %i2374 = load ptr, ptr %i236, align 8
  %i240 = icmp ult ptr null, %i2332
  %i242 = getelementptr double, ptr %i233, i64 %i241
  %i243 = icmp ult ptr %i242, null
  %i245 = getelementptr double, ptr %i235, i64 %i241
  %i247 = icmp ult ptr null, %i2374
  %i248 = getelementptr double, ptr %i237, i64 %i241
  %i249 = icmp ult ptr %i248, null
  %i250 = getelementptr double, ptr %i227, i64 %i241
  %i251 = icmp ult ptr %i250, %i2332
  %i252 = icmp ult ptr %i242, %i2271
  %i253 = icmp ult ptr %i250, %i2353
  %i254 = icmp ult ptr %i245, %i2271
  %i255 = icmp ult ptr %i250, null
  %i256 = icmp ult ptr null, %i2271
  %i257 = icmp ult ptr null, %i2353
  %i258 = icmp ult ptr %i245, null
  %i259 = icmp ult ptr %i242, null
  %i260 = icmp ult ptr null, %i2332
  %i261 = icmp ult ptr null, %i2374
  %i262 = icmp ult ptr %i248, null
  %i263 = or i1 %i240, %i243
  %i265 = and i1 %i263, false
  %i266 = or i1 %i247, %i249
  %i267 = and i1 %i265, %i266
  %i268 = or i1 %i251, %i252
  %i269 = and i1 %i267, %i268
  %i270 = or i1 %i253, %i254
  %i271 = and i1 %i269, %i270
  %i272 = or i1 %i255, %i256
  %i273 = and i1 %i271, %i272
  %i274 = or i1 %i257, %i258
  %i275 = and i1 %i273, %i274
  %i276 = or i1 %i259, %i260
  %i277 = and i1 %i275, %i276
  %i278 = or i1 %i261, %i262
  %i279 = and i1 %i277, %i278
  ret i1 %i279
}
