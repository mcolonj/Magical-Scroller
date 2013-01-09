# A Magical Infinitely Scrolling UIScrollView.

## Infinite Scroller - with 3 views and an overlay. ##


The UIPageControl is great, but how would you create an infinite scroller without using a whole lot of memory.

Easy with a little iOS magic. A simple slight of hand will allow you to simulate infinite scroll with just three UIViews and a UIScrollView.

The secret lies in the overlay view. A UIView that is hidden and displayed without the users knowledge. Hiding the scrollview just long enough to scroll the hidden scrollview and fix the scrolling data to appear seamless.


### Loading The Scroll View ###

1. A UIScrollView is added to a UIView.
2. Three UIView are added to the UIScrollView
3. Each UIView is loaded with data
4. When the UIScrollView is scrolled, an overlay UIView is placed over the UIScrollView to hide it.
5. The overlay UIView is a replica of the current visible UIView.
6. The UIScrollView is scrolled back to the center UIView.
7. Each UIView in the UIScrollView is loaded with its new data/look.
8. The overlay UIView is hidden.


This process happens each time a scroll occurs. It gives the appearance of an infinitely scrolling UIScrollView.

However it only contains three UIViews and an overlay UIView providing the slight-of-hand magic.
