export type User = {
  id?: string;
	/** 昵称 */
  nickname?: string;
	/** 头像 */
  avatar?: string;
  /** 经度 */
  longitude?: number;
  /** 维度 */
  latitude?: number;
	/** 更新时间戳 */
	updatedAt?: number;
};
