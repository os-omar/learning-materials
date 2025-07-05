package main

import "fmt"

//	func main() {
//		productNames := [4]string{"A Book", "B Book", "C Book", "D Book"}
//		prices := [4]float64{10.99, 20.49, 5.99, 15.00}
//		fmt.Println("Prices:", prices)
//		fmt.Println("Product Names:", productNames)
//		fmt.Println("Product Names[0]:", productNames[0])
//		featuredPrices := prices[1:3] // Slice from index 1 to 2 (exclusive)
//		fmt.Println("Featured Prices:", featuredPrices)
//		fmt.Println("cap(prices[:3]):", cap(prices[:3]))
//		fmt.Println("cap(prices[2:]):", cap(prices[2:]))
//		fmt.Println("len(Featured Prices):", len(featuredPrices))
//		fmt.Println("cap(Featured Prices):", cap(featuredPrices))
//	}
func main() {
	prices := []float64{10.99, 20.49}
	fmt.Println("Prices:", prices[0:1])
	prices[1] = 15.00                          // Update the second price
	prices = append(prices, 5.99, 12.3, 22.44) // Append a new price
	fmt.Println("Updated Prices:", prices)

	discountedPrices := []float64{11.11, 22.22}
	prices = append(prices, discountedPrices...) // Append all elements from discountedPrices
	fmt.Println("Prices after appending discounted prices:", prices)
}
