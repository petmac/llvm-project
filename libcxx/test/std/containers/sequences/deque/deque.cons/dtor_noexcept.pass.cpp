//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <deque>

// ~deque() // implied noexcept;

// UNSUPPORTED: c++03

#include <deque>
#include <cassert>

#include "test_macros.h"
#include "MoveOnly.h"
#include "test_allocator.h"

template <class T>
struct some_alloc {
  typedef T value_type;
  some_alloc(const some_alloc&);
  ~some_alloc() noexcept(false);
  void allocate(std::size_t);
};

int main(int, char**) {
  {
    typedef std::deque<MoveOnly> C;
    static_assert(std::is_nothrow_destructible<C>::value, "");
  }
  {
    typedef std::deque<MoveOnly, test_allocator<MoveOnly>> C;
    static_assert(std::is_nothrow_destructible<C>::value, "");
  }
  {
    typedef std::deque<MoveOnly, other_allocator<MoveOnly>> C;
    static_assert(std::is_nothrow_destructible<C>::value, "");
  }
#if defined(_LIBCPP_VERSION)
  {
    typedef std::deque<MoveOnly, some_alloc<MoveOnly>> C;
    static_assert(!std::is_nothrow_destructible<C>::value, "");
  }
#endif // _LIBCPP_VERSION

  return 0;
}
