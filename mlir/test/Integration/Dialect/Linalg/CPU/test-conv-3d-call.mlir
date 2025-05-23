// RUN: mlir-opt %s -test-transform-dialect-erase-schedule -convert-linalg-to-loops -convert-scf-to-cf  -expand-strided-metadata -lower-affine -convert-arith-to-llvm -convert-scf-to-cf --finalize-memref-to-llvm -convert-func-to-llvm -convert-cf-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-runner -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_runner_utils \
// RUN: | FileCheck %s

// RUN: mlir-opt %s -transform-interpreter -test-transform-dialect-erase-schedule -convert-linalg-to-loops -convert-scf-to-cf \
// RUN:    -expand-strided-metadata -lower-affine -convert-arith-to-llvm -convert-scf-to-cf --finalize-memref-to-llvm -convert-func-to-llvm -convert-cf-to-llvm -reconcile-unrealized-casts | \
// RUN: mlir-runner -e main -entry-point-result=void \
// RUN:   -shared-libs=%mlir_runner_utils \
// RUN: | FileCheck %s

func.func private @printMemrefF32(memref<*xf32>)

// Creates and returns 3-D buffer of size (%s1, %s2, %s3) filled with the value %f
func.func @alloc_3d_filled_f32(%s1 : index, %s2 : index, %s3 : index, %f : f32) -> memref<?x?x?xf32> {
  %buf = memref.alloc(%s1, %s2, %s3) : memref<?x?x?xf32>
  linalg.fill ins(%f : f32) outs(%buf : memref<?x?x?xf32>)
  return %buf : memref<?x?x?xf32>
}

func.func @conv_3d(%arg0: memref<?x?x?xf32>, %arg1: memref<?x?x?xf32>, %arg2: memref<?x?x?xf32>) {
  linalg.conv_3d ins (%arg0, %arg1: memref<?x?x?xf32>, memref<?x?x?xf32>)
                outs (%arg2: memref<?x?x?xf32>)
  return
}

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg1: !transform.any_op {transform.readonly}) {
    %0 = transform.structured.match ops{["linalg.conv_3d"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    %1, %loops:3 = transform.structured.tile_using_for %0 tile_sizes [2, 2, 2] : (!transform.any_op) -> (!transform.any_op, !transform.any_op, !transform.any_op, !transform.any_op)
    transform.yield
  }
}

func.func @main() {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c3 = arith.constant 3 : index
  %c6 = arith.constant 6 : index
  %c8 = arith.constant 8 : index
  %f10 = arith.constant 10.00000e+00 : f32
  %val = arith.constant 2.00000e+00 : f32
  %zero = arith.constant 0.00000e+00 : f32

  %filter3D = call @alloc_3d_filled_f32(%c3, %c3, %c3, %val) : (index, index, index, f32) -> (memref<?x?x?xf32>)
  %in3D = call @alloc_3d_filled_f32(%c8, %c8, %c8, %val) : (index, index, index, f32) -> (memref<?x?x?xf32>)
  %out3D = call @alloc_3d_filled_f32(%c6, %c6, %c6, %zero) : (index, index, index, f32) -> (memref<?x?x?xf32>)

  memref.store %f10, %in3D[%c0, %c0, %c3] : memref<?x?x?xf32>
  call @conv_3d(%in3D, %filter3D, %out3D) : (memref<?x?x?xf32>, memref<?x?x?xf32>, memref<?x?x?xf32>) -> ()
  %out3D_ = memref.cast %out3D : memref<?x?x?xf32> to memref<*xf32>
  call @printMemrefF32(%out3D_): (memref<*xf32>) -> ()

  memref.dealloc %filter3D : memref<?x?x?xf32>
  memref.dealloc %in3D : memref<?x?x?xf32>
  memref.dealloc %out3D : memref<?x?x?xf32>
  return
}

// CHECK:       Unranked Memref {{.*}}
// CHECK-NEXT:  [
// CHECK-SAME:   [
// CHECK-SAME:    [108,    124,    124,    124,    108,    108],
// CHECK-COUNT-5: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ],
// CHECK-NEXT:   [
// CHECK-COUNT-6: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ],
// CHECK-NEXT:   [
// CHECK-COUNT-6: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ],
// CHECK-NEXT:   [
// CHECK-COUNT-6: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ],
// CHECK-NEXT:   [
// CHECK-COUNT-6: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ],
// CHECK-NEXT:   [
// CHECK-COUNT-6: [108,    108,    108,    108,    108,    108]
// CHECK-SAME:   ]
// CHECK-SAME:  ]
