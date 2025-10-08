// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title UserProfile
 * @dev 一个简单的用户档案合约，允许用户存储和检索姓名和个人简介
 */
contract UserProfile {
    // 用户档案结构体
    struct Profile {
        string name;
        string bio;
        address owner;
        uint256 lastUpdated;
    }

    // 映射：地址 -> 用户档案
    mapping(address => Profile) public profiles;

    // 事件：当档案创建或更新时触发
    event ProfileUpdated(
        address indexed user,
        string name,
        string bio,
        uint256 timestamp
    );

    /**
     * @dev 设置或更新用户档案
     * @param _name 用户名
     * @param _bio 个人简介
     */
    function setProfile(string memory _name, string memory _bio) public {
        // 验证输入数据不为空
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_bio).length > 0, "Bio cannot be empty");

        // 限制简介长度（可选，防止过长的文本）
        require(bytes(_bio).length <= 280, "Bio too long");

        // 创建或更新档案
        profiles[msg.sender] = Profile({
            name: _name,
            bio: _bio,
            owner: msg.sender,
            lastUpdated: block.timestamp
        });

        // 触发事件
        emit ProfileUpdated(msg.sender, _name, _bio, block.timestamp);
    }

    /**
     * @dev 获取调用者的完整档案
     * @return name 用户名
     * @return bio 个人简介
     * @return lastUpdated 最后更新时间戳
     */
    function getMyProfile()
        public
        view
        returns (string memory name, string memory bio, uint256 lastUpdated)
    {
        Profile memory profile = profiles[msg.sender];
        require(profile.owner != address(0), "Profile does not exist");

        return (profile.name, profile.bio, profile.lastUpdated);
    }

    /**
     * @dev 获取指定地址的用户档案
     * @param _user 用户地址
     * @return name 用户名
     * @return bio 个人简介
     * @return lastUpdated 最后更新时间戳
     */
    function getUserProfile(
        address _user
    )
        public
        view
        returns (string memory name, string memory bio, uint256 lastUpdated)
    {
        Profile memory profile = profiles[_user];
        require(profile.owner != address(0), "Profile does not exist");

        return (profile.name, profile.bio, profile.lastUpdated);
    }

    /**
     * @dev 检查用户是否有档案
     * @param _user 用户地址
     * @return 如果档案存在返回true，否则false
     */
    function profileExists(address _user) public view returns (bool) {
        return profiles[_user].owner != address(0);
    }

    /**
     * @dev 获取档案最后更新时间
     * @param _user 用户地址
     * @return 最后更新时间戳
     */
    function getLastUpdated(address _user) public view returns (uint256) {
        require(profileExists(_user), "Profile does not exist");
        return profiles[_user].lastUpdated;
    }

    /**
     * @dev 删除调用者的档案（重置为默认值）
     */
    function deleteProfile() public {
        require(profileExists(msg.sender), "Profile does not exist");

        // 删除档案（实际上是将档案重置）
        delete profiles[msg.sender];

        emit ProfileUpdated(msg.sender, "", "", block.timestamp);
    }
}
