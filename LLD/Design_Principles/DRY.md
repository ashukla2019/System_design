# DRY (Don't Repeat Yourself)

## Definition
- Avoid duplicate code; keep logic in one place  
- Use reusable functions, classes, or modules  
- Benefits: maintainability, fewer bugs, consistency, readability  

---

## Related Principle
- **SRP (Single Responsibility Principle):** One module = one responsibility  
- DRY + SRP → clean, modular, maintainable code  

---

## How to Apply DRY
- Create **functions/methods** for repeated logic  
- Use **classes/inheritance** for reuse  
- Extract **constants/configurations**  
- Follow **modular design**  

---

## Example (C++)

### ❌ Without DRY
```cpp
#include <iostream>
#include <string>
using namespace std;

bool validateEmail1(const string& email) {
    return email.find("@") != string::npos &&
           email.find(".") != string::npos;
}

bool validateEmail2(const string& email) {
    return email.find("@") != string::npos &&
           email.find(".") != string::npos;
}

With Dry:
#include <iostream>
#include <string>
using namespace std;

bool validateEmail(const string& email) {
    return email.find("@") != string::npos &&
           email.find(".") != string::npos;
}

int main() {
    string email = "test@example.com";

    if (validateEmail(email)) {
        cout << "Valid\n";
    }
    return 0;
}