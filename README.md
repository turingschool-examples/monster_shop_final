# Monster Shop Extensions


## Instructions

* Fork this repository
* Clone your fork
* When you are finished, push your code to your fork.

#### Implementation Guidelines

1. Exisiting tests should still pass. Since you will need to make major changes to your database schema, you will probably break **many** tests. It's recommended that you focus on the completion criteria described above before going back and refactoring your code so that your existing tests still work.
1. Every order show page should display the chosen shipping address.
1. Statistics related to city/state should still work as before.

# Additional Extensions

## Coupon Codes

#### General Goals

Merchant users can generate coupon codes within the system.

#### Completion Criteria

1. Merchant users have a link on their dashboard to manage their coupons.
1. Merchant userss have full CRUD functionality over their coupons with exceptions mentioned below:
   - merchant users cannot delete a coupon that has been used in an order
   - Note: Coupons cannot be for greater than 100% off.

1. A coupon will have a coupon name, a coupon code, and a percent-off value. The name must be unique in the whole database. 
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


# Rubric

| | **Feature Completeness** | **Rails** | **ActiveRecord** | **Testing and Debugging** | **Styling, UI/UX** |
| --- | --- | --- | --- | --- | --- |
| **4: Exceptional**  | One or more additional extension features complete. | Students implement strategies not discussed in class to effectively organize code and adhere to MVC. | Highly effective and efficient use of ActiveRecord beyond what we've taught in class. Even `.each` calls will not cause additional database lookups. | Very clear Test Driven Development. Test files are extremely well organized and nested. Students utilize `before :each` blocks. 100% coverage for features and models | Extremely well styled and purposeful layout. Excellent color scheme and font usage. All other rubric categories score 3 or 4. |
| **3: Passing** | Multiple address feature 100% complete, including all sad paths and edge cases | Students use the principles of MVC to effectively organize code. Students can defend any of their design decisions. | ActiveRecord is used in a clear and effective way to read/write data using no Ruby to process data. | 100% coverage for models. 98% coverage for features. Tests are well written and meaningful. All preexisting tests still pass. | Purposeful styling pattern and layout using `application.html.erb`. Links or buttons to reach all areas of the site. |
| **2: Passing with Concerns** | One of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students utilize MVC to organize code, but cannot defend some of their design decisions. Or some functionality is not limited to the appropriately authorized users. | Ruby is used to process data that could use ActiveRecord instead. | Feature test coverage between 90% and 98%, or model test coverage below 100%, or tests are not meaningfully written or have an unclear objective. | Styling is poor or incomplete. Incomplete navigation for some routes, i.e. users must manually type URLs. |
| **1: Failing** | More than one of the completion criteria for Multiple Address feature is not complete or fails to handle a sad path or edge case | Students do not effectively organize code using MVC. Or students do not authorize users. | Ruby is used to process data more often than ActiveRecord | Below 90% coverage for either features or models. | No styling or no buttons or links to navigate the site. |
