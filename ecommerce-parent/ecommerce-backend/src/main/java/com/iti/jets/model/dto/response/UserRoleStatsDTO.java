package com.iti.jets.model.dto.response;

import lombok.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class UserRoleStatsDTO {
    private long adminCount;
    private long userCount;
}
