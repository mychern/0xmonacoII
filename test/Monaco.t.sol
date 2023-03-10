// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../src/Monaco.sol";
import "../src/cars/ExampleCar.sol";

contract MonacoTest is Test {
    Monaco monaco;

    function setUp() public {
        monaco = new Monaco();
    }

    function testGames() public {
        ExampleCar w1 = new ExampleCar();
        ExampleCar w2 = new ExampleCar();
        ExampleCar w3 = new ExampleCar();

        monaco.register(w1);
        monaco.register(w2);
        monaco.register(w3);

        // You can throw these CSV logs into Excel/Sheets/Numbers or a similar tool to visualize a race!
        vm.writeFile(string.concat("logs/", vm.toString(address(w1)), ".csv"), "turns,balance,speed,y,shield\n");
        vm.writeFile(string.concat("logs/", vm.toString(address(w2)), ".csv"), "turns,balance,speed,y,shield\n");
        vm.writeFile(string.concat("logs/", vm.toString(address(w3)), ".csv"), "turns,balance,speed,y,shield\n");
        vm.writeFile("logs/prices.csv", "turns,accelerateCost,shellCost,superShellCost,shieldCost\n");
        vm.writeFile("logs/sold.csv", "turns,acceleratesBought,shellsBought,superShellBought,shieldsBought\n");

        while (monaco.state() != Monaco.State.DONE) {
            monaco.play(1);

            emit log("");

            Monaco.CarData[] memory allCarData = monaco.getAllCarData();

            for (uint256 i = 0; i < allCarData.length; i++) {
                Monaco.CarData memory car = allCarData[i];

                emit log_address(address(car.car));
                emit log_named_uint("balance", car.balance);
                emit log_named_uint("speed", car.speed);
                emit log_named_uint("y", car.y);
                emit log_named_uint("shield", car.shield);

                vm.writeLine(
                    string.concat("logs/", vm.toString(address(car.car)), ".csv"),
                    string.concat(
                        vm.toString(uint256(monaco.turns())),
                        ",",
                        vm.toString(car.balance),
                        ",",
                        vm.toString(car.speed),
                        ",",
                        vm.toString(car.y),
                        ",",
                        vm.toString(car.shield)
                    )
                );

                vm.writeLine(
                    "logs/prices.csv",
                    string.concat(
                        vm.toString(uint256(monaco.turns())),
                        ",",
                        vm.toString(monaco.getAccelerateCost(1)),
                        ",",
                        vm.toString(monaco.getShellCost(1)),
                        ",",
                        vm.toString(monaco.getSuperShellCost(1)),
                        ",",
                        vm.toString(monaco.getShieldCost(1))
                    )
                );

                vm.writeLine(
                    "logs/sold.csv",
                    string.concat(
                        vm.toString(uint256(monaco.turns())),
                        ",",
                        vm.toString(monaco.getActionsSold(Monaco.ActionType.ACCELERATE)),
                        ",",
                        vm.toString(monaco.getActionsSold(Monaco.ActionType.SHELL)),
                        ",",
                        vm.toString(monaco.getActionsSold(Monaco.ActionType.SUPER_SHELL)),
                        ",",
                        vm.toString(monaco.getActionsSold(Monaco.ActionType.SHIELD))
                    )
                );
            }
        }

        emit log_named_uint("Number Of Turns", monaco.turns());
    }
}
