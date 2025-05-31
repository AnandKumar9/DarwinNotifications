Two sample iOS apps to let you play with [Darwin notifications](https://developer.apple.com/documentation/DarwinNotify).

DarwinNotificationProducer | DarwinNotificationConsumer
-- | --
![](/assets/Image-2025-05-31-3.25.51PM.png) | ![](/assets/Image-2025-05-31-3.34.41PM.png)

#### DarwinNotificationProducer.xcodeproj

On every tap of the button - A fresh `notify_register_check` is done, followed by a `notify_set_state`, and then a `notify_post`. <br><br>
The editable textfield at the top shows the value that will be set in the state upon the first button tap. <br> The value set in the state upon a tap is shown in the label underneath the button. <br> Every succeeding button tap increments the value to be set in state by 1.

#### DarwinNotificationConsumer.xcodeproj

Does a `notify_register_dispatch` in viewDidLoad, in its observer callback reads the state with `notify_get_state` and shows that in the label with a prefix 'From observer - '. <br><br>
Also does a `notify_register_check` in viewDidLoad, reads the state, and shows that in the label with a prefix 'With observer - '. Does the same also when the button is tapped.
