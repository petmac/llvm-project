//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <map>

// multimap& operator=(multimap&& c)
//     noexcept(
//          allocator_type::propagate_on_container_move_assignment::value &&
//          is_nothrow_move_assignable<allocator_type>::value &&
//          is_nothrow_move_assignable<key_compare>::value);

// This tests a conforming extension

// UNSUPPORTED: c++03

#include <map>

#include "test_macros.h"
#include "MoveOnly.h"
#include "test_allocator.h"

template <class T>
struct some_comp {
  using value_type = T;
  some_comp& operator=(const some_comp&);
  bool operator()(const T&, const T&) const { return false; }
};

template <class T>
struct always_equal_alloc {
  using value_type = T;
  always_equal_alloc(const always_equal_alloc&);
  void allocate(std::size_t);
};

template <class T>
struct not_always_equal_alloc {
  int i;
  using value_type = T;
  not_always_equal_alloc(const not_always_equal_alloc&);
  void allocate(std::size_t);
};

template <template <class> class Alloc>
using multimap_alloc =
    std::multimap<MoveOnly, MoveOnly, std::less<MoveOnly>, Alloc<std::pair<const MoveOnly, MoveOnly>>>;

static_assert(std::is_nothrow_move_assignable<multimap_alloc<std::allocator>>::value, "");
static_assert(!std::is_nothrow_move_assignable<multimap_alloc<test_allocator>>::value, "");
#if TEST_STD_VER >= 17
static_assert(std::is_nothrow_move_assignable<multimap_alloc<always_equal_alloc>>::value, "");
#endif
static_assert(!std::is_nothrow_move_assignable<multimap_alloc<not_always_equal_alloc>>::value, "");
#if defined(_LIBCPP_VERSION)
static_assert(std::is_nothrow_move_assignable<multimap_alloc<other_allocator>>::value, "");
#endif // _LIBCPP_VERSION
static_assert(!std::is_nothrow_move_assignable<std::multimap<int, int, some_comp<int>>>::value, "");
