import "forge-std/Script.sol";
import {W_3_B_C_2} from "../src/Challenge2.sol";
import {LibKeys} from "../src/LibKeys.sol";
import {Data} from "../src/tools/Data.sol";
import {reimburser} from "../src/tools/Disburser.sol";

contract DeployChallenge1 is Script, LibKeys, Data {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PK");
        vm.startBroadcast(deployerPrivateKey);
        //challenge1 deployed address
        address challenge1;

        W_3_B_C_2 ctf = new W_3_B_C_2{value: 540 ether}(challenge1);
    }
}
