function steering_angle = get_steering_angle1(current_pose, wheelbase, target_point)
  % Transform target point to base_link frame
  vx = cos(current_pose.theta) * (target_point.Posi_X - current_pose.Posi_X) + ...
      sin(current_pose.theta) * (target_point.Posi_Y - current_pose.Posi_Y);
  vy = -sin(current_pose.theta) * (target_point.Posi_X - current_pose.Posi_X) + ...
      cos(current_pose.theta) * (target_point.Posi_Y - current_pose.Posi_Y);

  % Target angle
  eta = atan2(vy, vx);

  % Limit steering angle for special cases
  if eta > pi/2
    steering_angle = pi/2;
  elseif eta < -pi/2
    steering_angle = -pi/2;
  else
    % Distance to target point
    ld = sqrt((target_point.Posi_X - current_pose.Posi_X)^2 + (target_point.Posi_Y - current_pose.Posi_Y)^2);
    
    % Calculate steering angle
    steering_angle = atan2(wheelbase * sin(eta), ld / 2.0);
  end
end