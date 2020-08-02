### DB configure
* Create a discount table.
  - It will have  percentage_off and minimum quantity fields
  - Foreign key association
    - discounts to merchants


### Thoughts

* Only one discount is accepted and that will be the greatest percentage_off
* Orders show view page will display final discounted price
* Going to use README example of *5% discount on 5 or more items* but with change to amount of items being 5
* A discount will use the Cart model count_of method to calculate the quantity of a single item in the cart to implement the discount.
* Final discounted price will be in the order's show page.
