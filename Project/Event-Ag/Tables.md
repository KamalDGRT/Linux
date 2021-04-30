### Table 1: role

| Column Name |Field Name | Type |
|----|---|---|
|id | ID | integer(11) |
|r_name|Role Name| string(100) |
|r_code | Role Code | string(20) |
|description | Role Description | string(256) |
| status | Status of the Role | integer(4) |
| created_at | Created At | integer(11) |
| updated_at | Updated At | integer(11) |

### Table 2: user

| Column Name |Field Name | Type |
|----|---|---|
|id | ID | integer(11) |
| username | User Name | string(100) |
| auth_key | Authentication Key | |
| password_hash | Password Hash | |
| password_reset | Password Reset | |
| verification_token | Verification Token | |
| email | Email Address | |
| role | Role | integer(11) |
| status | Status of the User | integer(11) |
| created_at | Created At | integer(11) |
| updated_at | Updated At | integer(11) |

### Table 3: event/challenge

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| transaction_id | Transaction ID | string(16) |
| title | Event/Challenge Title | string(256) |
| description | Description | text |
| host | Host | string(126) |
| venue | Venue | string(126) |
| d_o_e | Date of Event/Challenge | datetime |
| time | Time of the Event/Challenge | string(16) |
| status | Status of the event/challenge | integer(4) |
| created_at | Created  At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |


### Table 4: testimonial

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| title | Title | string(126) |
| description | Description | text |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 5: faq

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| question | Question | string(256) |
| answer | Answer | text |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 6: instruction

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| description | Description | text |
| priority | Priority | integer(4) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 7: social

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| type | Type | integer(6) |
| link | Social Link | string(512) |
| img_link | Image Link | string(512) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 8: social_type

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| description | string(512) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 9: contact

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| p_name | Person's Name | string(512) |
| p_phone | Person's Phone | string(30) |
| p_email | Person's Email | string(512) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 10: timeline

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| date | Date of Event/Challenge | integer(11) |
| time | Time of Event/Challenge | string(20) |
| description | Description | string(256) |
| priority | Priority | integer(4) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 11: backer

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| event_id | Event ID | integer(11) |
| type | Type | integer(6) |
| link | Social Link | string(512) |
| img_link | Image Link | string(512) |
| b_type | Backer Type | integer(1) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

### Table 12: backer_type

| Column Name |Field Name | Type |
|----|---|---|
| id | ID | integer(11) |
| description | string(512) |
| created_at | Created At | integer(11) |
| created_by | Created By | integer(11) |
| updated_at | Updated At | integer(11) |
| updated_by | Updated By | integer(11) |

