# this utility will calculate the per paycheck contribution between 2 people to be proportionate to how much they make
# example
# person A makes 100000
# person B makes 200000
# they want a per month contribution of 9000
# person A should put in 3000 per month
# person B should put in 6000 per month
# but per paycheck would be:
# A -> 1384
# B -> 2769
# total = 4153 per paycheck
print("enter monthly expenses separated by enter. hit enter with empty line to stop")
try:
    monthly_expenses = [];
    while True:
        monthly_expenses.append(float(input()))
        print(f"current total monthly = {sum(monthly_expenses)}")
except:
    print(f"total monthly = {sum(monthly_expenses)}")

per_month_contribution = float(input("desired monthly contribution: "))
per_pay_check_total = per_month_contribution * 12 / 26
salary_a = float(input("salary A: "))
salary_b = float(input("salary B: "))
total_salary = salary_a+salary_b
A_contribution_factor = salary_a/total_salary
B_contribution_factor = salary_b/total_salary
A_contribution_per_paycheck = per_pay_check_total * A_contribution_factor
B_contribution_per_paycheck = per_pay_check_total * B_contribution_factor

print(f"A contributes ${A_contribution_per_paycheck} per paycheck")
print(f"B contributes ${B_contribution_per_paycheck} per paycheck")
print(f"for a total of ${per_pay_check_total} per paycheck")
