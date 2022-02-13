pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract DeTweet {
    event LogTweet(uint256, string);
    event LogFollower(address);
    event LogUnFollower(address);
    event LogLike(uint256);
    event LogUnLike(uint256);

    struct tweet {
        string message;
        address owner;
        uint256 numberOfLikes;
        mapping(address => uint256) isLiker;
        mapping(uint256 => address) idToLikerAddress;
    }
    struct user {
        string name;
        uint256 numberOfTweets;
        uint256 numberOfFollowers;
        uint256[] tweetsList;
        mapping(address => uint256) isFollower;
        mapping(uint256 => address) idToFollowerAddress;
    }
    mapping(address => user) public addressToUser;
    mapping(uint256 => tweet) public tweetsList;
    uint256 public numberOfTweets;

    /** 
     * @dev Function to tweet, called by user only
     * @param _message tweet message
     */
    function Tweet(string calldata _message) external {
        tweet storage t = tweetsList[numberOfTweets];
        t.message = _message;
        t.owner = msg.sender;
        user storage u = addressToUser[msg.sender];
        u.numberOfTweets += 1;
        u.tweetsList.push(numberOfTweets);
        numberOfTweets += 1;
        emit LogTweet(numberOfTweets-1, _message);
    }
    /** 
     * @dev set user profile name, called by user only
     * @param _name user profile name
     */
    function CreateUserName(string memory _name) public {
        addressToUser[msg.sender].name = _name;
    }

    /** 
     * @dev follow another user, called by user only
     * @param _dest follow user address
     */
    function FollowUser(address _dest) external {
        require(msg.sender != _dest, "Cannot follow self");
        user storage u = addressToUser[_dest];
        require(u.isFollower[msg.sender] == 0, "Already Following");
        u.numberOfFollowers += 1;
        uint256 numberOfFollowers = u.numberOfFollowers;
        u.isFollower[msg.sender] = numberOfFollowers;
        u.idToFollowerAddress[numberOfFollowers] = msg.sender;
        emit LogFollower(_dest);
    }
    /** 
     * @dev unfollow another user, called by user only
     * @param _dest unfollow user address
     */
    function UnFollowUser(address _dest) external {
        user storage u = addressToUser[_dest];
        require(u.isFollower[msg.sender] != 0, "Not Following");
        u.idToFollowerAddress[u.isFollower[msg.sender]] = u.idToFollowerAddress[u.numberOfFollowers];
        u.idToFollowerAddress[u.numberOfFollowers] = address(0);
        u.isFollower[msg.sender] = 0;
        u.numberOfFollowers -= 1;
        emit LogUnFollower(_dest);
    }
    /** 
     * @dev like tweet, called by user only
     * @param _index tweet index
     */
    function LikeTweet(uint256 _index) external {
        tweet storage t = tweetsList[_index];
        require(t.isLiker[msg.sender] == 0, "Already Liked");
        t.numberOfLikes += 1;
        uint256 numberOfLikes = t.numberOfLikes;
        t.isLiker[msg.sender] = numberOfLikes;
        t.idToLikerAddress[numberOfLikes] = msg.sender;
        emit LogLike(_index);
    }
    /** 
     * @dev unlike tweet, called by user only
     * @param _index tweet index
     */
    function UnLikeTweet(uint256 _index) external {
        tweet storage t = tweetsList[_index];
        require(t.isLiker[msg.sender] != 0, "Not Liked");
        t.idToLikerAddress[t.isLiker[msg.sender]] = t.idToLikerAddress[t.numberOfLikes];
        t.idToLikerAddress[t.numberOfLikes] = address(0);
        t.isLiker[msg.sender] = 0;
        t.numberOfLikes -= 1;
        emit LogUnLike(_index);
    } 
    /** 
     * @dev get followers for a user, anyone can call
     * @param _addr user address
     */
    function getFollowersList(address _addr) external view returns(address[] memory) {
        user storage u = addressToUser[_addr];
        uint256 len = u.numberOfFollowers;
        address[] memory a = new address[](len);
        for(uint256 i=0; i < len; i++) {
            a[i] = u.idToFollowerAddress[i+1];
        }
        return a;
    }
    /** 
     * @dev get followers count for a user, anyone can call
     * @param _addr user address
     */
    function getFollowersCount(address _addr) external view returns(uint256) {
        return addressToUser[_addr].numberOfFollowers;
    }
    /** 
     * @dev get likers address list for a tweet, anyone can call
     * @param _index tweet index
     */
    function getLikersList(uint256 _index) external view returns(address[] memory) {
        require(_index < numberOfTweets, "invalid Tweet id");
        tweet storage t = tweetsList[_index];
        uint256 len = t.numberOfLikes;
        address[] memory a = new address[](len);
        for(uint256 i=0; i < len; i++) {
            a[i] = t.idToLikerAddress[i+1];
        }
        return a;
    }
    /** 
     * @dev get likes count for a tweet, anyone can call
     * @param _index tweet index
     */
    function getLikesCount(uint256 _index) external view returns(uint256) {
        require(_index < numberOfTweets, "invalid Tweet id");
        return tweetsList[_index].numberOfLikes;
    }
    /** 
     * @dev get number of tweets for a user, anyone can call
     * @param _addr address of user
     */
    function getNumberOfTweetsbyUser(address _addr) external view returns(uint256) {
        return addressToUser[_addr].numberOfTweets;
    }
}


