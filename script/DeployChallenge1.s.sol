import "forge-std/Script.sol";
import {W_3_B_C_1} from "../src/Challenge1.sol";
import {LibKeys} from "../src/LibKeys.sol";
import {Data} from "../src/tools/Data.sol";

contract DeployChallenge1 is Script, LibKeys, Data {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PK");
        vm.startBroadcast(deployerPrivateKey);
        W_3_B_C_1 ctf = new W_3_B_C_1{value: 1260 ether}();
        //register all players

        ctf.massW(toDynamicVars(hackers), toDynamicVars(nicks));

        ctf.massH(getAllPossibleKeys());
    }

    function getAllPossibleKeys() internal view returns (bytes32[] memory t) {
        uint16 magicNo = 2929;
        string memory justAName = "ayodeji";
        string memory secretMissive = "supersimple"; //c3VwZXJzaW1wbGU= in base64
        string[] memory secrets = LibKeys.getkeys();

        t = new bytes32[](secrets.length);
        for (uint i = 0; i < secrets.length; i++) {
            string memory x = secrets[i];
            bytes32 key = sha256(
                abi.encodePacked(magicNo, justAName, secretMissive, x)
            );
            t[i] = key;
        }
    }

    function toDynamicVars(
        address[4] memory addr
    ) internal pure returns (address[] memory t_) {
        t_ = new address[](4);

        for (uint i = 0; i < 4; i++) {
            t_[i] = addr[i];
        }
    }

    function toDynamicVars(
        string[4] memory strs
    ) internal pure returns (string[] memory s_) {
        s_ = new string[](4);
        for (uint i = 0; i < 4; i++) {
            s_[i] = strs[i];
        }
    }
}
