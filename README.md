# Monster Shop Extensions - Bulk Discount


## Instructions

* Fork this repository or use your existing project.
* Clone your fork if you have forked.
* When you are finished, push your code to your fork. (if you have forked)

## Bulk Discount

#### General Goals

Merchants add bulk discount rates for all of their inventory. These apply automatically in the shopping cart, and adjust the order_items price upon checkout.

#### Completion Criteria

1. Merchants need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
1. You will implement a percentage based discount:
   - 5% discount on 20 or more items
1. A merchant can have multiple bulk discounts in the system.
1. When a user adds enough value or quantity of a single item to their cart, the bulk discount will automatically show up on the cart page.
1. A bulk discount from one merchant will only affect items from that merchant in the cart.
1. A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)
1. When there is a conflict between two discounts, the greater of the two will be applied.
1. Final discounted prices should appear on the orders show page.

#### Mod 2 Learning Goals reflected:
- Database relationships and migrations
- Advanced ActiveRecord
- Software Testing


### User Stories
```
User Story 1, Bulk discount index

As a merchant employee
When I visit the merchant dashboard ('/merchant')
I see a link to view all bulk discounts
When I click that link
I am taken to '/merchant/discounts'
Where I see the name, amount, item quantity (if applicable) and item value (if applicable) of each discount
The name of the discount is a link to its show page ('/merchant/discounts/:discount_id')
```

```
User Story 2, Bulk discount show page

As a merchant employee
When I visit a discount's show page ('/merchant/discounts/:discount_id')
I see the discount's:
- name
- amount
- item quantity (if applicable)
- item value (if applicable)
- the name of the merchant it is associated with
```

```
User Story 3, Bulk discount creation

As a merchant employee
When I visit the discount index page ('/merchant/discounts/')
I see a link to create a new discount, "New Bulk Discount"
When I click this link
Then I am taken to '/merchant/discounts/new' where I see a form for a new bulk discount
When I fill out the form with a new discount's:
- name
- amount
- item quantity (if applicable)
- item value (if applicable)
When I click submit
I see a flash message saying that a new bulk discount is created
And I am returned to the discount index page where I see the new discount listed.
```

```
User Story 4, Cannot create bulk discount with incomplete information

As a merchant employee
When I visit the new discount page ('/merchant/discounts/new')
And I fill out the form on that page without a discount's full information and click submit
I see a flash message saying information is incomplete
And I am still on the new discount page with prepopulated information
```

```
User Story 5, Bulk discount update

As a merchant employee
When I visit a discount's show page ('/merchant/discounts/:discount_id')
I see a link to "Update Discount"
When I click that link
I am taken to '/merchant/discounts/:discount_id/edit' where I see a form to edit the discount's data similar to the create form, which is prepopulated
When I edit the necessary entries and click submit
I see a flash message saying the discount is updated
And I am returned to the discount's show page where I see its updated information.
```

```
User Story 6, Cannot update Bulk discount with incomplete information

As a merchant employee
When I visit a discount's edit page ('/merchant/discounts/:discount_id/edit')
And I edit the form with incomplete information and click submit
When I edit the necessary entries and click submit
I see a flash message saying information is incomplete
And I am still on the edit discount page with prepopulated information
```

```
User Story 7, Bulk discount delete

As a merchant employee
When I visit a discount's show page ('/merchant/discounts/:discount_id')
I see a button to "Delete Discount"
When I click that button
I see a flash message saying the discount is deleted
And am redirected to the discount index page where I no longer see this discount
```

```
User Story 8, Bulk discount applies to items in cart

As any non-admin user or visitor
When I add items from a particular merchant to my cart which satisfy discount qualifications of that merchant
And I browse to my cart
I see strikethrough text on the value of the item or subtotal with the old value struck through and the discounted value next to it
This discount is only applied to items from that merchant
```

```
User Story 9, Bulk discount is taken away if qualifications stop being met

As any non-admin user or visitor
When I add items from a particular merchant to my cart which satisfy discount qualifications of that merchant
And I browse to my cart and see the discount applied
And I take an action to stop satisfying those qualifications (eg. by reducing the quantity of an item)
Then I can see the discount is no longer applied
```

```
User Story 10, Bulk discount only applies to items originally specified

As any non-admin user or visitor
And there is a "5% off 5 items of the same type or more" discount available
That discount does not apply if I have 5 items all of different types
But if I raise the quantity of one item to 5
The discount is applied only to that one item, not to the others
```

```
User Story 11, The greatest discount applies

As any non-admin user or visitor
When I add items from a particular merchant to my cart which satisfy discount qualifications of two or more discounts from that merchant
In the Cart I should only see the greatest discount applied
```

```
User Story 12, Bulk discount applies to items in order on its show page

As any non-admin user or visitor
When I add items from a particular merchant to my cart which satisfy discount qualifications of that merchant
And I check out my cart and create an order
I see that the discounted value of the items persists through to the order to its show page
```

```
User Story X, All discounts available are displayed on merchant show page

As any user or visitor
When I visit a merchant's show page
I can see all discounts available to me offered by that merchant at the top of the page
```

```
User Story X, All discounts available are displayed on merchant items index page

As any user or visitor
When I visit a merchant's items index page
I can see all discounts available to me offered by that merchant at the top of the page
```


---

# Additional Extensions

##  Users have multiple addresses

#### General Goal

Users will have more than one address associated with their profile. Each address will have a nickname like "home" or "work". Users will choose an address when checking out.

#### Completion Criteria

1. When a user registers they will still provide an address, this will become their first address entry in the database and nicknamed "home".
1. Users need full CRUD ability for addresses from their Profile page.
1. An address cannot be deleted or changed if it's been used in a "shipped" order.
1. When a user checks out on the cart show page, they will have the ability to choose one of their addresses where they'd like the order shipped.
1. If a user deletes all of their addresses, they cannot check out and see an error telling them they need to add an address first. This should link to a page where they add an address.
1. If an order is still pending, the user can change to which address they want their items shipped.

#### Implementation Guidelines

1. Existing tests should still pass. Since you will need to make major changes to your database schema, you will probably break **many** tests. It's recommended that you focus on the completion criteria described above before going back and refactoring your code so that your existing tests still work.
1. Every order show page should display the chosen shipping address.
1. Statistics related to city/state should still work as before.

---

## Merchant To-Do List

#### General Goals

Merchant dashboards will display a to-do list of tasks that need their attention.

#### Completion Criteria

1. Merchants should be shown a list of items which are using a placeholder image and encouraged to find an appropriate image instead; each item is a link to that item's edit form.
1. Merchants should see a statistic about unfulfilled items and the revenue impact. eg, "You have 5 unfulfilled orders worth $752.86"
1. Next to each order on their dashboard, Merchants should see a warning if an item quantity on that order exceeds their current inventory count.
1. If several orders exist for an item, and their summed quantity exceeds the Merchant's inventory for that item, a warning message is shown.

#### Implementation Guidelines

1. Make sure you are testing for all happy path and sad path scenarios.

#### Mod 2 Learning Goals reflected:

- MVC and Rails development
- Database relationships and migrations
- ActiveRecord
- Software Testing


# Rubric

| | **Feature Completeness**                                                                                                   | **Rails** | **ActiveRecord** | **Testing and Debugging**                                                                                                                                                                                               |
| --- | ---------------------------------------------------------------------------------------------------------------------------| --- | --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **4: Exceptional**  | One or more additional extension features complete.                                                                        | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models                                                   |
| **3: Passing** | Bulk discount feature 100% complete, including most sad paths and edge cases                                               | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. All preexisting tests still pass. TDD Process is clear throughout commits. Sad paths and edge cases are covered in testing. |
| **2: Passing with Concerns** | One to two of the completion criteria for Bulk Discount feature is not complete or fails to handle a big sad path or edge case     | Students utilize MVC to organize code, but cannot defend some of their design decisions. Or some functionality is not limited to the appropriately authorized users. | Ruby is used to process data that could use ActiveRecord instead. | Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective. Missing sad path or edge case testing.                                |
| **1: Failing** | More than two of the completion criteria for Bulk Discount feature is not complete or fails to handle a sad path or edge case| Students do not effectively organize code using MVC. Or students do not authorize users. | Ruby is used to process data more often than ActiveRecord | Below 90% coverage for either features or models. TDD was not used.                                                                                                                                                     |
