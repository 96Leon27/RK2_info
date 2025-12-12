#include <iostream>
using namespace std;

class BankAccount {
protected:
    double balance;
public:
    BankAccount(double b) : balance(b) {}
    void deposit(double amount) {
        if (amount > 0) balance += amount;
    }
    void withdraw(double amount) {
        if (amount > 0 && amount <= balance) balance -= amount;
    }
    double getBalance() { return balance; }
};

class SavingsAccount : public BankAccount {
private:
    double rate;
public:
    SavingsAccount(double b, double r) : BankAccount(b), rate(r) {}
    void applyInterest() {
        balance += balance * rate / 100;
    }
};

int main() {
    BankAccount acc(1000);
    acc.deposit(500);
    acc.withdraw(200);
    cout << "BankAccount: " << acc.getBalance() << endl;

    SavingsAccount sav(2000, 5);
    sav.deposit(1000);
    sav.applyInterest();
    sav.withdraw(500);
    cout << "SavingsAccount: " << sav.getBalance() << endl;

    return 0;
}
