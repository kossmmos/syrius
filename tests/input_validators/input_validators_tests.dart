import 'package:znn_sdk_dart/znn_sdk_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zenon_syrius_wallet_flutter/utils/utils.dart';

void main() {
  group('Node validation tests', () {
    test('Given null node, expect "Invalid Node"', () {
      String? result = InputValidators.node(null);
      expect(result, equals('Invalid Node'));
    });

    test('Given node with missing protocol, expect "Invalid Node"', () {
      String? result = InputValidators.node('syrius-testnet.zenon.community:443');
      expect(result, equals('Invalid Node'));
    });

    test('Given node with missing port, expect "Invalid Node"', () {
      String? result = InputValidators.node('wss://syrius-testnet.zenon.community');
      expect(result, equals('Invalid Node'));
    });

    test('Given correctly formatted node, expect valid result (null)', () {
      String? result = InputValidators.node('wss://syrius-testnet.zenon.community:443');
      expect(result, equals(null));
    });
  });

  group('Address validation tests', () {
    test('Given null value, expect "Value is null"', () {
      String? result = InputValidators.checkAddress(null);
      expect(result, equals('Value is null'));
    });

    test('Given empty value, expect "Enter an address"', () {
      String? result = InputValidators.checkAddress('');
      expect(result, equals('Enter an address'));
    });

    test('Given blank space value, expect "Invalid address"', () {
      String? result = InputValidators.checkAddress(' ');
      expect(result, equals('Invalid address'));
    });

    test('Given address with special character, expect "Invalid address"', () {
      String? result = InputValidators.checkAddress('z1qxemdeddedxplasmaxxxxxxxxxxxxxxxxsctrp!');
      expect(result, equals('Invalid address'));
    });

    test('Given address with trailing space, expect "Invalid address"', () {
      String? result = InputValidators.checkAddress('z1qxemdeddedxplasmaxxxxxxxxxxxxxxxxsctrp ');
      expect(result, equals('Invalid address'));
    });

    test('Given address with leading space, expect "Invalid address"', () {
      String? result = InputValidators.checkAddress(' z1qxemdeddedxplasmaxxxxxxxxxxxxxxxxsctrp');
      expect(result, equals('Invalid address'));
    });

    test('Given valid address, expect valid result (null)', () {
      String? result = InputValidators.checkAddress('z1qxemdeddedxplasmaxxxxxxxxxxxxxxxxsctrp');
      expect(result, equals(null));
    });
  });

  group('Password match validation tests', () {
    test('Given different passwords, expect "Passwords do not match"', () {
      String? result = InputValidators.checkPasswordMatch('password123', 'pasword123');
      expect(result, equals('Passwords do not match'));
    });

    test('Given null confirmation password, expect "Passwords do not match"', () {
      String? result = InputValidators.checkPasswordMatch('password123', null);
      expect(result, equals('Passwords do not match'));
    });

    test('Given confirmation password with leading space, expect "Passwords do not match"', () {
      String? result = InputValidators.checkPasswordMatch('password123', ' password123');
      expect(result, equals('Passwords do not match'));
    });

    test('Given matching passwords, expect valid result (null)', () {
      String? result = InputValidators.checkPasswordMatch('password123', 'password123');
      expect(result, equals(null));
    });
  });

  group('Password strength validation tests', () {
    test('Given null password, expect "Value is null"', () {
      String? result = InputValidators.validatePassword(null);
      expect(result, equals('Value is null'));
    });

    test('Given password with characters < 8, expect "Password not strong enough"', () {
      String? result = InputValidators.validatePassword('H@l0');
      expect(result, equals('Password not strong enough'));
    });

    test('Given password with only lowercase letters, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('hellokitty');
      expect(result, equals('Invalid password'));
    });

    test('Given password with only uppercase letters, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('HELLOKITTY');
      expect(result, equals('Invalid password'));
    });

    test('Given password with uppercase and lowercase but no numbers, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('HELLOkitty');
      expect(result, equals('Invalid password'));
    });

    test('Given password with uppercase, lowercase, and numbers but no symbols, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('HELLOkitty911');
      expect(result, equals('Invalid password'));
    });

    test('Given password with lowercase and numbers but no symbols, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('kitty911');
      expect(result, equals('Invalid password'));
    });

    test('Given password with uppercase, lowercase, and symbols but no numbers, expect "Invalid password"', () {
      String? result = InputValidators.validatePassword('HELLOkitty@');
      expect(result, equals('Invalid password'));
    });

    test('Given strong password, expect valid result (null)', () {
      String? result = InputValidators.validatePassword('Hell0kitty#911#');
      expect(result, equals(null));
    });
  });

    group('Pillar momentum address validation tests', () {
      List<String?>? testAddressList;

      setUpAll(() {
        testAddressList = ['z1qql4e9xs3twyh52afk6drl5nhv8c8swlf3cvlx',
          emptyAddress.toString()];
      });

      test('Given null address, expect "Value is null"', () {
        String? result = InputValidators.validatePillarMomentumAddress(null, testAddressList!);
        expect(result, equals('Value is null'));
      });

      test('Given address that belongs to the user, expect "Pillar producer address[...]"', () {
        String? result = InputValidators.validatePillarMomentumAddress(emptyAddress.toString(), testAddressList!);
        expect(result, equals('Pillar producer address must be generated from a different seed'));
      });

      test('Given valid address, expect valid result (null)', () {
        String? result = InputValidators.validatePillarMomentumAddress('z1qxemdeddedxplasmaxxxxxxxxxxxxxxxxsctrp', testAddressList!);
        expect(result, equals(null));
      });
    });
}
