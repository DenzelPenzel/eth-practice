/*
Parent contracts can be called directly, or by using the keyword super.

By using super, all immediate parent contracts will be called.

Task:
    Complete H.bar() by calling bar on parents using super.

    This function will call G.bar, F.bar and then finally E.bar.


*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract E {
    // This event will be used to trace function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("E.foo");
    }

    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E {
    function foo() public virtual override {
        emit Log("F.foo");
        E.foo();
    }

    function bar() public virtual override {
        emit Log("F.bar");
        super.bar();
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo");
        E.foo();
    }

    function bar() public virtual override {
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F, G {
    function foo() public override(F, G) {
        // Calls G.foo() and then E.foo()
        // Inside F and G, E.foo() is called. Solidity is smart enough
        // to not call E.foo() twice. Hence E.foo() is only called by G.foo().
        super.foo();
    }

    function bar() public override(F, G) {
        // Write your code here
        super.bar();
    }
}



