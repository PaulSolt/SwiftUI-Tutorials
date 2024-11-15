# Payment Calculator
2024-11-14

Create a Mockup of a Payment Calculator and calculate the PMT value for a loan amount.

<img src="Hero-PaymentCalculator.png" alt="" style="width: 300px"/>

## Custom Components

* Slider
* Navigation Bar
* Term Selector

## PMT

Calculates the periodic payment loan amount for each month similar to the Excel function.

	PMT function is P = (Pv*R) / (1 - (1 + R)^(-n))

	P = Monthly Payment
	Pv = Present Value (starting value of the loan)
	APR = Annual Percentage Rate
	R = Periodic Interest Rate = APR/number of interest periods per year
	n = Total number of interest periods (interest periods per year * number of years)

