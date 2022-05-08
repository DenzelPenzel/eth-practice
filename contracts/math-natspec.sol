/// @title A contract for basic math operations
/// @author H4XF13LD MORRIS 💯💯😎💯💯
/// @notice For now, this contract just adds a multiply function
contract Math {
    /// @notice Multiplies 2 numbers together
    /// @param x the first uint.
    /// @param y the second uint.
    /// @return z the product of (x * y)
    /// @dev This function does not currently check for overflows
    function multiply(uint256 x, uint256 y) returns (uint256 z) {
        // This is just a normal comment, and won't get picked up by natspec
        z = x * y;
    }
}
