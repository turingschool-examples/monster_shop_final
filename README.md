# Monster Shop Extensions


## Instructions

* Fork this repository or use your existing project.
* Clone your fork if you have forked.
* When you are finished, push your code to your fork. (if you have forked)

## Coupon Codes

#### General Goals

Merchant users can generate coupon codes within the system.

#### Completion Criteria

1. Merchant users have a link on their dashboard to manage their coupons.
1. Merchant users have full CRUD functionality over their coupons with exceptions mentioned below:
   - merchant users cannot delete a coupon that has been used in an order
   - Note: Coupons cannot be for greater than 100% off.

1. A coupon will have a coupon name, a coupon code, and a percent-off value. The name and coupon code must be unique in the whole database. 
1. Users need a way to add a coupon code when checking out. Only one coupon may be used per order.
1. A coupon code from a merchant only applies to items sold by that merchant.


#### Implementation Guidelines

1. If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page. (This information should not be stored in the database until after checkout. )
1. The cart show page should calculate subtotals and the grand total as usual, but also show a "discounted total".
1. Users can enter different coupon codes until they finish checking out, then the last code entered before clicking checkout is final.
1. Order show pages should display which coupon was used, as well as the discounted price.

#### Extensions
1. Coupons can be used by multiple users, but may only be used one time per user.
1. Merchant users can enable/disable coupon codes
1. Merchant users can have a maximum of 5 coupons in the system

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

# Additional Extensions

## Bulk Discount

#### General Goals

Merchants add bulk discount rates for all of their inventory. These apply automatically in the shopping cart, and adjust the order_items price upon checkout.

#### Completion Criteria

1. Merchants need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
1. You can choose what type of bulk discount to implement: percentage based, or dollar based. For example:
   - 5% discount on 20 or more items
   - $10 off an order of $50 or more
1. A merchant can have multiple bulk discounts in the system.
1. When a user adds enough value or quantity of items to their cart, the bulk discount will automatically show up on the cart page.
1. A bulk discount from one merchant will only affect items from that merchant in the cart.
1. A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)

#### Implementation Guidelines

1. When an order is created during checkout, try to adjust the price of the items in the order_items table.

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- Advanced ActiveRecord
- Software Testing
- HTML/CSS layout and styling

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

| | **Feature Completeness** | **Rails** | **ActiveRecord** | **Testing and Debugging** | **Styling, UI/UX** |
| --- | --- | --- | --- | --- | --- |
| **4: Exceptional**  | One or more additional extension features complete. | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models | Extremely well styled and purposeful layout. Excellent color scheme and font usage. All other rubric categories score 3 or 4. |
| **3: Passing** | Multiple address feature 100% complete, including all sad paths and edge cases | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. All preexisting tests still pass. | Purposeful styling pattern and layout using `application.html.erb`. Links or buttons to reach all areas of the site. |
| **2: Passing with Concerns** | One of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students utilize MVC to organize code, but cannot defend some of their design decisions. Or some functionality is not limited to the appropriately authorized users. | Ruby is used to process data that could use ActiveRecord instead. | Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective. | Styling is poor or incomplete. Incomplete navigation for some routes, i.e. users must manually type URLs. |
| **1: Failing** | More than one of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students do not effectively organize code using MVC. Or students do not authorize users. | Ruby is used to process data more often than ActiveRecord | Below 90% coverage for either features or models. | No styling or no buttons or links to navigate the site. |
