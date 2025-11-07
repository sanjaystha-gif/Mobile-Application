
// ------------------------------------------------------
// 1️ Abstract Base Class: BankAccount
// ------------------------------------------------------
abstract class BankAccount {
  //  Private fields (Encapsulation)
  String _accountNumber;
  String _accountHolder;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  // Getters (read-only access)
  String get accountNumber => _accountNumber;
  String get accountHolder => _accountHolder;
  double get balance => _balance;

  // Setter for account holder (write with validation)
  set accountHolder(String name) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Account holder name cannot be empty.');
    }
    _accountHolder = name;
  }

  // Helper to safely change balance (like protected in other languages)
  void changeBalance(double amount) {
    _balance += amount;
  }

  // Abstract methods (to be implemented differently in subclasses)
  void withdraw(double amount);
  void deposit(double amount);

  //  Common method for all accounts
  void displayInfo() {
    print('-----------------------------');
    print('Account Number: $_accountNumber');
    print('Account Holder: $_accountHolder');
    print('Balance: \$${_balance.toStringAsFixed(2)}');
    print('-----------------------------');
  }
}

// ------------------------------------------------------
// 2️ Interface / Abstract class for Interest-Bearing Accounts
// ------------------------------------------------------
abstract class InterestBearing {
  void calculateInterest();
}

// ------------------------------------------------------
// 3 SavingsAccount Class
// ------------------------------------------------------
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500.0;
  static const double interestRate = 0.02; // 2%
  int _withdrawCount = 0;

  SavingsAccount(String number, String holder, double balance)
      : super(number, holder, balance);

  @override
  void withdraw(double amount) {
    if (_withdrawCount >= 3) {
      print('Withdrawal limit reached (3 per month).');
      return;
    }
    if (balance - amount < minBalance) {
      print('Cannot withdraw — must maintain minimum balance of \$500.');
      return;
    }
    changeBalance(-amount);
    _withdrawCount++;
    print('Withdrawn \$${amount.toStringAsFixed(2)} successfully.');
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    changeBalance(amount);
    print('Deposited \$${amount.toStringAsFixed(2)} successfully.');
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    changeBalance(interest);
    print(' Interest of \$${interest.toStringAsFixed(2)} added.');
  }
}

// ------------------------------------------------------
// 4️ CheckingAccount Class
// ------------------------------------------------------
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35.0;

  CheckingAccount(String number, String holder, double balance)
      : super(number, holder, balance);

  @override
  void withdraw(double amount) {
    changeBalance(-amount);
    if (balance < 0) {
      changeBalance(-overdraftFee);
      print('Overdraft! Fee of \$35 charged.');
    }
    print('Withdrawn \$${amount.toStringAsFixed(2)} successfully.');
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    changeBalance(amount);
    print('Deposited \$${amount.toStringAsFixed(2)} successfully.');
  }
}

// ------------------------------------------------------
// 5️ PremiumAccount Class
// ------------------------------------------------------
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;
  static const double interestRate = 0.05; // 5%

  PremiumAccount(String number, String holder, double balance)
      : super(number, holder, balance);

  @override
  void withdraw(double amount) {
    if (balance - amount < 0) {
      print('Insufficient balance.');
      return;
    }
    changeBalance(-amount);
    print('Withdrawn \$${amount.toStringAsFixed(2)} successfully.');
  }

  @override
  void deposit(double amount) {
    if (amount <= 0) {
      print('Deposit amount must be positive.');
      return;
    }
    changeBalance(amount);
    print('Deposited \$${amount.toStringAsFixed(2)} successfully.');
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    changeBalance(interest);
    print('Premium interest of \$${interest.toStringAsFixed(2)} added.');
  }
}

// ------------------------------------------------------
// 6️ Bank Class – Manages All Accounts
// ------------------------------------------------------
class Bank {
  List<BankAccount> _accounts = [];

  // Create a new account
  void createAccount(BankAccount account) {
    _accounts.add(account);
    print('New account created for ${account.accountHolder}');
  }

  // Find account by number
  BankAccount? findAccount(String number) {
    for (var acc in _accounts) {
      if (acc.accountNumber == number) {
        return acc;
      }
    }
    print('Account not found.');
    return null;
  }

  // Transfer between accounts
  void transfer(String fromNum, String toNum, double amount) {
    BankAccount? from = findAccount(fromNum);
    BankAccount? to = findAccount(toNum);

    if (from == null || to == null) return;

    if (from.balance < amount) {
      print(' Insufficient funds to transfer.');
      return;
    }

    from.withdraw(amount);
    to.deposit(amount);
    print(' Transferred \$${amount.toStringAsFixed(2)} successfully.');
  }

  //  Display all account info
  void showAllAccounts() {
    print('\n --- All Accounts Report ---');
    for (var acc in _accounts) {
      acc.displayInfo();

      //  Type check & safe casting for interest-bearing accounts
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
      }
    }
  }
}

// ------------------------------------------------------
// 7️ Main Function (Program Execution)
// ------------------------------------------------------
void main() {
  Bank bank = Bank();

  // Create different accounts
  var acc1 = SavingsAccount('1001', 'Alice', 1000);
  var acc2 = CheckingAccount('1002', 'Bob', 200);
  var acc3 = PremiumAccount('1003', 'Charlie', 15000);

  // Add accounts to bank
  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  //  Perform some transactions
  acc1.deposit(200);
  acc1.withdraw(300);
  acc1.withdraw(100);
  acc1.withdraw(50); // exceeds withdrawal limit

  acc2.withdraw(250); // overdraft fee

  acc3.withdraw(5000);
  acc3.calculateInterest();

  // Transfer money between accounts
  bank.transfer('1001', '1002', 100);

  // Show all accounts info
  bank.showAllAccounts();
}
